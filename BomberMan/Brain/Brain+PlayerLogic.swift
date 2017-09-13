//
//  Brain+PlayerLogic.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/7/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    func move(to direction: Direction, player: inout Player) {
        var directionPosition: Int
        var shouldRedraw = false
        
        switch direction {
        case .bottom: directionPosition = player.position + width
        case .left: directionPosition = player.position - 1
        case .right: directionPosition = player.position + 1
        case .top: directionPosition = player.position - width
        }
        if playerCanGo(to: directionPosition) {
            let last = tiles[directionPosition].last ?? " "
            switch last {
            case "F":
                tiles[player.position].removeLast()
                if let intValue = Int(player.markForScene.description) {
                    move?(direction, intValue)
                    killHero?(intValue)
                    gameEnd?(false)
                    score -= 1000
                    if score < 0 {
                        score = 0
                    }
                    refreshScore?(score)
                    return
                }
            case "U":
                if let index = getUpgradeIndex(atPosition: directionPosition) {
                    switch upgrades[index].type {
                    case .anotherBomb:
                        player.minesCount += 1
                    case .strongerBomb:
                        player.explosionPower += 1
                    }
                    tiles[directionPosition].removeFirst()
                    upgrades.remove(at: index)
                    score += 100
                    refreshScore?(score)
                    shouldRedraw = true
                }
            case "D":
                if let intValue = Int(player.markForScene.description) {
                    score += 500
                    refreshScore?(score)
                    move?(direction, intValue)
                    gameEnd?(true)
                    return
                }
            case "M":
                tiles[player.position].removeLast()
                if let intValue = Int(player.markForScene.description) {
                    move?(direction, intValue)
                    killHero?(intValue)
                    gameEnd?(false)
                    score -= 1000
                    if score < 0 {
                        score = 0
                    }
                    refreshScore?(score)
                    return
                }
            default:
                break
            }
            tiles[player.position].removeLast()
            tiles[directionPosition].append(player.markForScene)
            player.position = directionPosition
            if let intValue = Int(player.markForScene.description) {
                move?(direction, intValue)
            }
            if shouldRedraw {
                redrawScene?()
            }
        }
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
    
    func plantBomb(player: inout Player) {
        if player.minesCount > player.plantedMines, canFitBomb(at: player.position)  {
            tiles[player.position].insert("X", at: 0)
            player.plantedMines += 1
            startBombTimer(withOptionsOfPlayer: player)
            
            if let intValue = Int(player.markForScene.description) {
                plantBomb?(intValue)
            }
        }
    }
}
