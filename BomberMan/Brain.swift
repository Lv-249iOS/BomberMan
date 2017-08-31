//
//  Explosion.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 8/26/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

class Brain {
    static let shared = Brain()
    private var sceneData: String = "WWWWWWWWWWW  P     WW        WW        WW  B BBB WW  B B   WW  BBBBB WW    B B WW  BBB B WWWWWWWWWWW"
    private var sceneWidth = 10
    private var player = Player.init(markForScene: "P", canFly: false, minesCount: 1, explosionPower: 1)
    var gameTimer: Timer!
    var showFire: ((Explosion, String.Index)->())?

    func appendScene(with width: Int, scene: String) {
        sceneData = scene
        sceneWidth = width
    }
    
    func entryPointsCount(for testStr: String, char: Character) -> Int {
        var count = 0
        for c in testStr.characters {
            if c == char {
                count += 1
            }
        }
        return count
    }
    
    func shareScene() -> String {
        return sceneData
    }

    func move(to direction: Direction, player: Player) -> Bool {
        if let playerPosition = sceneData.characters.index(of: "P") ?? sceneData.characters.index(of: "Q") {
            switch direction {
            case .bottom:
                if sceneData[sceneData.characters.index(playerPosition, offsetBy: sceneWidth)] == " " {
                    if sceneData[playerPosition] == "P" {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert(" ", at: playerPosition)
                    } else {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert("X", at: playerPosition)
                    }
                    sceneData.characters.remove(at: sceneData.index(playerPosition, offsetBy: sceneWidth))
                    sceneData.characters.insert("P", at: sceneData.index(playerPosition, offsetBy: sceneWidth))
                    return true
                }
            case .left:
                if sceneData[sceneData.characters.index(before: playerPosition)] == " " {
                    if sceneData[playerPosition] == "P" {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert(" ", at: playerPosition)
                    } else {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert("X", at: playerPosition)
                    }
                    sceneData.characters.remove(at: sceneData.index(before: playerPosition))
                    sceneData.characters.insert("P", at: sceneData.index(before: playerPosition))
                    return true
                }
            case .right:
                if sceneData[sceneData.characters.index(after: playerPosition)] == " " {
                    if sceneData[playerPosition] == "P" {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert(" ", at: playerPosition)
                    } else {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert("X", at: playerPosition)
                    }
                    sceneData.characters.remove(at: sceneData.index(after: playerPosition))
                    sceneData.characters.insert("P", at: sceneData.index(after: playerPosition))
                    return true
                }
            case .top:
                if sceneData[sceneData.characters.index(playerPosition, offsetBy: -sceneWidth)] == " " {
                    if sceneData[playerPosition] == "P" {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert(" ", at: playerPosition)
                    } else {
                        sceneData.characters.remove(at: playerPosition)
                        sceneData.characters.insert("X", at: playerPosition)
                    }
                    sceneData.characters.remove(at: sceneData.index(playerPosition, offsetBy: -sceneWidth))
                    sceneData.characters.insert("P", at: sceneData.index(playerPosition, offsetBy: -sceneWidth))
                    return true
                }
            }
        }
        return false
    }
    
    func plantBomb() -> Bool {
        if let playerPosition = sceneData.characters.index(of: "P"), player.minesCount > entryPointsCount(for: sceneData, char: "X")  {
            sceneData.characters.remove(at: playerPosition)
            sceneData.characters.insert("Q", at: playerPosition)
            startTimer(at: playerPosition, power: player.explosionPower)
            return true
        }
        return false
    }
    
    func startTimer(at position: String.Index, power: Int) {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
            self?.explode(at: position, power: power)
            self?.gameTimer.invalidate()
        })
    }
    
    func explode(at position: String.Index, power: Int) {
        var explosion = Explosion.init()
        sceneData.characters.remove(at: position)
        sceneData.characters.insert("F", at: position)
        for i in 1...power + 1 {
            let indexForFire = sceneData.characters.index(position, offsetBy: i * sceneWidth)
            if sceneData[indexForFire] != "W" {
                sceneData.remove(at: indexForFire)
                sceneData.insert("F", at: indexForFire)
                explosion.bottom += 1
            } else {
                break
            }
        }
        for i in 1...power + 1 {
            let indexForFire = sceneData.characters.index(position, offsetBy: -i * sceneWidth)
            if sceneData[indexForFire] != "W" {
                sceneData.remove(at: indexForFire)
                sceneData.insert("F", at: indexForFire)
                explosion.top += 1
            } else {
                break
            }
        }
        for i in 1...power + 1 {
            let indexForFire = sceneData.characters.index(position, offsetBy: i)
            if sceneData[indexForFire] != "W" {
                sceneData.remove(at: indexForFire)
                sceneData.insert("F", at: indexForFire)
                explosion.right += 1
            } else {
                break
            }
        }
        for i in 1...power + 1 {
            let indexForFire = sceneData.characters.index(position, offsetBy: -i)
            if sceneData[indexForFire] != "W" {
                sceneData.remove(at: indexForFire)
                sceneData.insert("F", at: indexForFire)
                explosion.left += 1
            } else {
                break
            }
        }
        showFire?(explosion, position)
        //call method from map send explosion + position
    }
}
