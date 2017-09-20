//
//  Brain+PlayerLogic.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/7/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation



extension Brain {
    
    func move(to direction: Direction, playerName: String) {
        var playerIndex = 0
        for player in players {
            if player.name == playerName {
                break
            }
            playerIndex += 1
        }
        if !players[playerIndex].isAlive { return }
        var directionPosition: Int
        var shouldRedraw = false
        
        switch direction {
        case .bottom: directionPosition = players[playerIndex].position + width
        case .left: directionPosition = players[playerIndex].position - 1
        case .right: directionPosition = players[playerIndex].position + 1
        case .top: directionPosition = players[playerIndex].position - width
        }
        if playerCanGo(to: directionPosition), directionPosition > 0, directionPosition < tiles.count {
            let last = tiles[directionPosition].last ?? " "
            switch last {
            case "F":
                tiles[players[playerIndex].position].removeLast()
                players[playerIndex].isAlive = false
                
                DispatchQueue.main.async { [weak self] in
                    self?.move?(direction, self!.players[playerIndex].identifier)
                    self?.killHero?(self!.players[playerIndex].identifier, false)
                }
                
                if isSingleGame {
                    gameEnd?(false)
                }
                score -= 1000
                if score < 0 {
                    score = 0
                }
                if alivePlayersCount() <= 1, !isSingleGame {
                    multiplayerEnd?()
                }
                refreshScore?(score)
                return
            case "U":
                if let index = getUpgradeIndex(atPosition: directionPosition) {
                    switch upgrades[index].type {
                    case .anotherBomb:
                        players[playerIndex].minesCount += 1
                    case .strongerBomb:
                        players[playerIndex].explosionPower += 1
                    }
                    tiles[directionPosition].removeFirst()
                    upgrades.remove(at: index)
                    score += 100
                    refreshScore?(score)
                    shouldRedraw = true
                }
            case "D":
                if doorEnterCount == 0 {
                    score += 500
                    refreshScore?(score)
                    move?(direction, players[playerIndex].identifier)
                    if isSingleGame {
                        gameEnd?(true)
                    }
                    doorEnterCount = 1
                }
                return
            case "M":
                if players[playerIndex].position < tiles.count, !tiles[players[playerIndex].position].isEmpty {
                    tiles[players[playerIndex].position].removeLast()
                }
                players[playerIndex].isAlive = false
                move?(direction, players[playerIndex].identifier)
                killHero?(players[playerIndex].identifier, false)
                gameEnd?(false)
                score -= 1000
                if score < 0 {
                    score = 0
                }
                refreshScore?(score)
                return
            default:
                break
            }
            if players[playerIndex].position < tiles.count, !tiles[players[playerIndex].position].isEmpty {
                tiles[players[playerIndex].position].removeLast()
            }
            
            players[playerIndex].position = directionPosition
            tiles[directionPosition].append("P")
            DispatchQueue.main.async { [weak self] in
                self?.move!(direction, self!.players[playerIndex].identifier)
                
                if shouldRedraw {
                    self?.redrawScene?()
                }
            }
            
        }
    }
    
    func alivePlayersCount() -> Int {
        var count = 0
        for player in players {
            if player.isAlive {
                count += 1
            }
        }
        return count
    }
    
    func playerCanGo(to directionPosition: Int) -> Bool {
        guard directionPosition >= 0 && directionPosition < tiles.count else {
            fatalError("Invalid directionPosition position")
        }
        
        for char in tiles[directionPosition].reversed() {
            if cantGo.characters.contains(char) {
                return false
            }
        }
        return true
    }
    
    func canFitBomb(at position: Int) -> Bool {
        for char in tiles[position] {
            if char == "B" { return false }
            if char == "X" { return false }
        }
        return true
    }
    
    func plantBomb(playerName: String) {
        var playerIndex = 0
        for player in players {
            if player.name == playerName {
                break
            }
            playerIndex += 1
        }
        if !players[playerIndex].isAlive { return }
        if players[playerIndex].minesCount > players[playerIndex].plantedMines, canFitBomb(at: players[playerIndex].position)  {
            tiles[players[playerIndex].position].insert("X", at: 0)
            players[playerIndex].plantedMines += 1
            startBombTimer(withOptionsOfPlayer: players[playerIndex])
            
            DispatchQueue.main.async { [weak self] in
                self?.plantBomb?(self!.players[playerIndex].identifier)
            }
            
        }
    }
}
