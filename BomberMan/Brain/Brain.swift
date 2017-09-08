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
    
    //used at the beginning of the game
    func initializeGame(with lvlNumber: Int, completelyNew: Bool) {
        currentLvl = lvlNumber
        setlevel(numberoflevel: currentLvl)
        self.scene.data = scene.data
        self.scene.width = scene.width
        currentTime = timeLimit
        door.health = 2
        mobs.removeAll()
        upgrades.removeAll()
        if completelyNew {
            score = 0
            player = Player(name: player.name, markForScene: player.markForScene, minesCount: 1, explosionPower: 1)
            refreshScore?(score)
        }
        
        var i = 0
        var mobIdentifier = 0
        for char in scene.data.characters {
            let index = scene.data.characters.index(scene.data.startIndex, offsetBy: i)
            switch char {
            case "M":
                let mob = Mob(identifier: mobIdentifier,
                              animationSpeed: 1,
                              position: index,
                              direction: setMobDirection())
                mobIdentifier += 1
                mobs.append(mob)
            case "U":
                let randomType = arc4random_uniform(2)
                guard let type = UpgradeType(rawValue: Int(randomType)) else { return }
                let upgrade = Upgrade.init(health: 2, position: index, type: type)
                upgrades.append(upgrade)
            default: break
            }
            i += 1
        }
        
        redrawScene?()
        startMobsMovement()
        startGameTimer()
    }
    
    func setlevel(numberoflevel: Int) {
        let currentlevel: String
        let width: Int
        if numberoflevel == 0 {
            width = 10
        }
        else {
            width  = 15
        }
        currentlevel = Levels().level(with: numberoflevel)
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
    
    func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { [weak self] _ in
            self?.gameEnd?(false)
        }
        
        timers.append(gameTimer)
    }
    
            self?.moveMobs()
        }
        
        timers.append(mobsTimer)
    }
    
    func stopMobsMovement() {
        mobsTimer.invalidate()
    }
    
    func startBombTimer(at position: String.Index, power: Int) {
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            self?.explode(at: position, power: power)
        }
        
        timers.append(timer)
    }
    
    func startFireTimer(explosion: Explosion, position: String.Index) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.fadeFire(explosion: explosion, position: position)
        }
        
        timers.append(timer)
    }
    
    
    func invalidateTimers() {
        for timer in timers {
            timer.invalidate()
        }
        
        timers = []
    }
}
