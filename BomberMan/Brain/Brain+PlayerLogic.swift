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
        func removePlayerMark(atPosition position: String.Index) {
            if scene.data[position] == player.markForScene {
                scene.data.characters.remove(at: position)
                scene.data.characters.insert(" ", at: position)
            } else {
                scene.data.characters.remove(at: position)
                scene.data.characters.insert("X", at: position)
            }
        }
        if let playerPosition = scene.data.characters.index(of: player.markForScene) ?? scene.data.characters.index(of: "Q") {
            var directionPosition: String.Index
            var canGo = true
            var shouldRedraw = false
            
            switch direction {
            case .bottom: directionPosition = scene.data.characters.index(playerPosition, offsetBy: scene.width)
            case .left: directionPosition = scene.data.characters.index(before: playerPosition)
            case .right: directionPosition = scene.data.characters.index(after: playerPosition)
            case .top: directionPosition = scene.data.index(playerPosition, offsetBy: -scene.width)
                
            }
            if !cantGo.characters.contains(scene.data[directionPosition]) {
                switch scene.data[directionPosition] {
                case "F":
                    removePlayerMark(atPosition: playerPosition)
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
                    if let index = getUpgradeIndex(atPosition: directionPosition), upgrades[index].health == 1 {
                        switch upgrades[index].type {
                        case .anotherBomb:
                            player.minesCount += 1
                        case .strongerBomb:
                            player.explosionPower += 1
                        }
                        upgrades.remove(at: index)
                        score += 100
                        refreshScore?(score)
                        shouldRedraw = true
                    } else {
                        canGo = false
                    }
                case "D":
                    if door.health == 2 {
                        canGo = false
                    } else {
                        if let intValue = Int(player.markForScene.description) {
                            score += 500
                            refreshScore?(score)
                            move?(direction, intValue)
                            gameEnd?(true)
                            return
                        }
                    }
                case "M":
                    removePlayerMark(atPosition: playerPosition)
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
                if canGo {
                    removePlayerMark(atPosition: playerPosition)
                    scene.data.characters.remove(at: directionPosition)
                    scene.data.characters.insert(player.markForScene, at: directionPosition)
                    if let intValue = Int(player.markForScene.description) {
                        move?(direction, intValue)
                    }
                    if shouldRedraw {
                        redrawScene?()
                    }
                }
            }
        }
    }
    
    func plantBomb(player: Player) {
        if let playerPosition = scene.data.characters.index(of: player.markForScene), player.minesCount > entryPointsCount(for: scene.data, char: "X")  {
            scene.data.characters.remove(at: playerPosition)
            scene.data.characters.insert("Q", at: playerPosition)
            startBombTimer(at: playerPosition, power: player.explosionPower)
            if let intValue = Int(player.markForScene.description) {
                plantBomb?(intValue)
            }
            return
        }
        return
    }
}
