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
    private var scene = Scene.init(data: "WWWWWWWWWWW  P     WW        WW        WW  B BBB WW  B B   WW  BBBBB WW    B B WW  BBB B WWWWWWWWWWW", width: 10)
    private var player = Player.init(markForScene: "P", canFly: false, minesCount: 1, explosionPower: 1)
    var gameTimer: Timer!
    var showFire: ((Explosion, String.Index)->())?
    var move: ((Direction, Int)->())?
    var plantBomb: ((Int)->())?
    var cantGo = "WBXQ"
    var ifCanFly = "W"

    func appendScene(with width: Int, data: String) {
        scene.data = data
        scene.width = width
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
    
    func shareScene() -> Scene {
        return scene
    }

    func move(to direction: Direction, player: Player) {
        if let playerPosition = scene.data.characters.index(of: "P") ?? scene.data.characters.index(of: "Q") {
            switch direction {
            case .bottom:
                let directionPosition = scene.data.characters.index(playerPosition, offsetBy: scene.width)
                if !cantGo.characters.contains(scene.data[directionPosition]) {
                    if scene.data[playerPosition] == "P" {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert(" ", at: playerPosition)
                    } else {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert("X", at: playerPosition)
                    }
                    scene.data.characters.remove(at: directionPosition)
                    scene.data.characters.insert("P", at: directionPosition)
                    if let intValue = Int(player.markForScene.description) {
                        move?(direction, intValue)
                    }
                    return
                }
            case .left:
                let directionPosition = scene.data.characters.index(before: playerPosition)
                if !cantGo.characters.contains(scene.data[directionPosition]) {
                    if scene.data[playerPosition] == "P" {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert(" ", at: playerPosition)
                    } else {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert("X", at: playerPosition)
                    }
                    scene.data.characters.remove(at: directionPosition)
                    scene.data.characters.insert("P", at: directionPosition)
                    if let intValue = Int(player.markForScene.description) {
                        move?(direction, intValue)
                    }
                    return
                }
            case .right:
                let directionPosition = scene.data.characters.index(after: playerPosition)
                if !cantGo.characters.contains(scene.data[directionPosition]) {
                    if scene.data[playerPosition] == "P" {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert(" ", at: playerPosition)
                    } else {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert("X", at: playerPosition)
                    }
                    scene.data.characters.remove(at: directionPosition)
                    scene.data.characters.insert("P", at: directionPosition)
                    if let intValue = Int(player.markForScene.description) {
                        move?(direction, intValue)
                    }
                    return
                }
            case .top:
                let directionPosition = scene.data.index(playerPosition, offsetBy: -scene.width)
                if !cantGo.characters.contains(scene.data[directionPosition]) {
                    if scene.data[playerPosition] == "P" {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert(" ", at: playerPosition)
                    } else {
                        scene.data.characters.remove(at: playerPosition)
                        scene.data.characters.insert("X", at: playerPosition)
                    }
                    scene.data.characters.remove(at: directionPosition)
                    scene.data.characters.insert("P", at: directionPosition)
                    if let intValue = Int(player.markForScene.description) {
                        move?(direction, intValue)
                    }
                    return
                }
            }
        }
        return
    }
    
    func plantBomb(player: Player) {
        if let playerPosition = scene.data.characters.index(of: "P"), player.minesCount > entryPointsCount(for: scene.data, char: "X")  {
            scene.data.characters.remove(at: playerPosition)
            scene.data.characters.insert("Q", at: playerPosition)
            startTimer(at: playerPosition, power: player.explosionPower)
            if let intValue = Int(player.markForScene.description) {
                plantBomb?(intValue)
            }
            return
        }
        return
    }
    
    func startTimer(at position: String.Index, power: Int) {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
            self?.explode(at: position, power: power)
            self?.gameTimer.invalidate()
        })
    }
    
    func explode(at position: String.Index, power: Int) {
        var explosion = Explosion.init()
        scene.data.characters.remove(at: position)
        scene.data.characters.insert("F", at: position)
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: i * scene.width)
            if scene.data[indexForFire] != "W" {
                scene.data.remove(at: indexForFire)
                scene.data.insert("F", at: indexForFire)
                explosion.bottom += 1
            } else {
                break
            }
        }
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: -i * scene.width)
            if scene.data[indexForFire] != "W" {
                scene.data.remove(at: indexForFire)
                scene.data.insert("F", at: indexForFire)
                explosion.top += 1
            } else {
                break
            }
        }
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: i)
            if scene.data[indexForFire] != "W" {
                scene.data.remove(at: indexForFire)
                scene.data.insert("F", at: indexForFire)
                explosion.right += 1
            } else {
                break
            }
        }
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: -i)
            if scene.data[indexForFire] != "W" {
                scene.data.remove(at: indexForFire)
                scene.data.insert("F", at: indexForFire)
                explosion.left += 1
            } else {
                break
            }
        }
        showFire?(explosion, position)
        //call method from map send explosion + position
    }
}
