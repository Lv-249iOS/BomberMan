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
    
    var tiles: [[Character]] = []
    var width = 0
    var cantGo = "WBXQ"
    var mobCantGo = "WBXQUD"
    var mobs: [Mob] = []
    var upgrades: [Upgrade] = []
    var player = Player(name: "Player",
                        markForScene: "0",
                        minesCount: 1,
                        explosionPower: 1,
                        position: 0,
                        plantedMines: 0)
    var gameTimer: Timer!
    var mobsTimer: Timer!
    var score = 0
    var currentLvl = 0
    
    var timers: [Timer] = []
    var currentTime: TimeInterval = 120
    let timeLimit: TimeInterval = 120
    
    var showFire: ((Explosion, Int)->())?
    var move: ((Direction, Int)->())?
    var plantBomb: ((Int)->())?
    var showImage: ((DoubleHealthThings, Int)->())?
    var redrawScene: (()->())?
    var killHero: ((Int)->())?
    var killMob: ((Int)->())?
    var moveMob: ((Direction, Int)->())?
    var gameEnd: ((Bool)->())?
    var presentTime: ((Double)->())?
    var refreshScore: ((Int)->())?
    
    // Used at the beginning of the game
    func initializeGame(with lvlNumber: Int, completelyNew: Bool) {
        resetScore(ifNeeded: completelyNew)
        setLevel(with: lvlNumber)
        addMobsAndUpgrates()
        redrawScene?()
        startMobsMovement()
        startGameTimer()
    }
    
    func addMobsAndUpgrates() {
        var i = 0, mobIdentifier = 0
        for char in tiles {
            if !char.isEmpty {
                switch char[0] {
                case "M":
                    generateNewMob(with: mobIdentifier, on: i)
                    mobIdentifier += 1
                case "U":
                    generateNewUpgrate(on: i)
                default:
                    break
                }
            }
            i += 1
        }
    }
    
    // Adds upgrates in upgrate_arr
    func generateNewUpgrate(on position: Int) {
        let randomType = arc4random_uniform(2)
        guard let type = UpgradeType(rawValue: Int(randomType)) else { return }
        let upgrade = Upgrade(position: position, type: type)
        upgrades.append(upgrade)
    }
    
    // Adds mob in mobs_array
    func generateNewMob(with identifier: Int, on position: Int) {
        let mob = Mob(identifier: identifier,
                      animationSpeed: 1,
                      position: position,
                      direction: setMobDirection())
        
        mobs.append(mob)
    }
    
    func toTiles(scene: String) {
        for char in scene.characters {
            var tile: [Character] = []
            switch char {
            case "U","D":
                tile.append(char)
                tile.append("B")
            case " " : break
            default:
                tile.append(char)
            }
            tiles.append(tile)
        }
    }
    
    func getPlayerPosition(from scene: String) {
        player.position = scene.distance(from: scene.startIndex,
                                              to: scene.characters.index(of: "0") ?? scene.startIndex)
    }
    
    // if it's completely new game, reset score and create new player
    func resetScore(ifNeeded completelyNew: Bool) {
        if completelyNew {
            score = 0
            player = Player(name: "Player",
                            markForScene: "0",
                            minesCount: 1,
                            explosionPower: 1,
                            position: 0,
                            plantedMines: 0)
            refreshScore?(score)
        }
    }
    
    // Changes current level, updates scene/timer/health, delete mobs and upgrades
    func setLevel(with levelNum: Int) {
        currentLvl = levelNum
        setlevel(numberoflevel: currentLvl)
        currentTime = timeLimit
        mobs.removeAll()
        upgrades.removeAll()
    }
    
    // create new scene
    func setlevel(numberoflevel: Int) {
        width = numberoflevel == 0 ? 10 : 15
        let currentlevel = Levels().level(with: numberoflevel)
        toTiles(scene: currentlevel)
        getPlayerPosition(from: currentlevel)
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
    
    func getUpgradeIndex(atPosition position: Int) -> Int? {
        var i = 0
        for item in upgrades {
            if item.position == position {
                return i
            }
            i += 1
        }
        return nil
    }
}
