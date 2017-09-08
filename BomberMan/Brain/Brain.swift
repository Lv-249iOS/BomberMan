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
    
    var scene = Scene(data: Levels().level(with: 0), width: 10)
    var cantGo = "WBXQ"
    var mobCantGo = "WBXQUD"
    var mobs: [Mob] = []
    var upgrades: [Upgrade] = []
    var player = Player(name: "Player", markForScene: "0", minesCount: 1, explosionPower: 1)
    var door = Door()
    var gameTimer: Timer!
    var mobsTimer: Timer!
    var score = 0
    var currentLvl = 0
    
    var timers: [Timer] = []
    var currentTime: TimeInterval = 120
    let timeLimit: TimeInterval = 120
    
    var showFire: ((Explosion, String.Index)->())?
    var move: ((Direction, Int)->())?
    var plantBomb: ((Int)->())?
    var showImage: ((DoubleHealthThings, String.Index)->())?
    var redrawScene: (()->())?
    var killHero: ((Int)->())?
    var killMob: ((Int)->())?
    var moveMob: ((Direction, Int)->())?
    var gameEnd: ((Bool)->())?
    var presentTime: ((Double)->())?
    var refreshScore: ((Int)->())?
    
    // Used at the beginning of the game
    func initializeGame(with lvlNumber: Int, completelyNew: Bool) {
        setLevel(with: lvlNumber)
        resetScore(ifNeeded: completelyNew)
        addMobsAndUpgrates()
        redrawScene?()
        startMobsMovement()
        startGameTimer()
    }
    
    func addMobsAndUpgrates() {
        var i = 0, mobIdentifier = 0
        for char in scene.data.characters {
            let posIndex = scene.data.characters.index(scene.data.startIndex, offsetBy: i)
            switch char {
            case "M":
                generateNewMob(with: mobIdentifier, on: posIndex)
                mobIdentifier += 1
            case "U":
                generateNewUpgrate(on: posIndex)
            default:
                break
            }
            
            i += 1
        }
    }
    
    // Adds upgrates in upgrate_arr
    func generateNewUpgrate(on position: String.CharacterView.Index) {
        let randomType = arc4random_uniform(2)
        guard let type = UpgradeType(rawValue: Int(randomType)) else { return }
        let upgrade = Upgrade(health: 2, position: position, type: type)
        upgrades.append(upgrade)
    }
    
    // Adds mob in mobs_array
    func generateNewMob(with identifier: Int, on position: String.CharacterView.Index) {
        let mob = Mob(identifier: identifier,
                      animationSpeed: 1,
                      position: position,
                      direction: setMobDirection())
        
        mobs.append(mob)
    }
    
    // if it's completely new game, reset score and create new player
    func resetScore(ifNeeded completelyNew: Bool) {
        if completelyNew {
            score = 0
            player = Player(name: player.name, markForScene: player.markForScene, minesCount: 1, explosionPower: 1)
            refreshScore?(score)
        }
    }
    
    // Changes current level, updates scene/timer/health, delete mobs and upgrades
    func setLevel(with levelNum: Int) {
        currentLvl = levelNum
        setlevel(numberoflevel: currentLvl)
        self.scene.data = scene.data
        self.scene.width = scene.width
        currentTime = timeLimit
        door.health = 2
        mobs.removeAll()
        upgrades.removeAll()
    }
    
    // create new scene
    func setlevel(numberoflevel: Int) {
        let width = numberoflevel == 0 ? 10 : 15
        let currentlevel = Levels().level(with: numberoflevel)
        scene = Scene(data: currentlevel, width: width)
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
    
    func getUpgradeIndex(atPosition position: String.Index) -> Int? {
        var i = 0
        for item in upgrades {
            if item.position == position {
                return i
            }
            i += 1
        }
        return nil
    }
    
    func shareScene() -> Scene {
        return scene
    }
}
