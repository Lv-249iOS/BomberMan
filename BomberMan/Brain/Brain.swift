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
    
    var isSingleGame = true
    var isHost = false
    var tiles: [[Character]] = []
    var width = 0
    var cantGo = "WBXQ"
    var mobCantGo = "WBXQUD"
    var mobs: [Mob] = []
    var upgrades: [Upgrade] = []
    var bombs: [Bomb] = []
    var devices: [String] = []
    var players: [Player] = []

    var mobsTimer: Timer!
    var score = 0
    var currentLvl = 0
    var doorEnterCount = 0
    var timers: [Timer] = []
    var currentTime: TimeInterval = 120
    let timeLimit: TimeInterval = 120
    
    var showFire: ((Explosion, Int)->())?
    var move: ((Direction, Int)->())?
    var plantBomb: ((Int)->())?
    var showImage: ((DoubleHealthThings, Int)->())?
    var redrawScene: (()->())?
    var killHero: ((Int, Bool)->())?
    var killMob: ((Int, Bool)->())?
    var moveMob: ((Direction, Int)->())?
    var gameEnd: ((Bool)->())?
    var presentTime: ((Double)->())?
    var refreshScore: ((Int)->())?
    var boxExplode: ((Int)->())?
    var multiplayerEnd: ((String)->())?
    var getPlayer: (()->(String))?
    var setUpgradesIfNeeded: (()->())?
    
    // Used at the beginning of the game
    func initializeGame(with lvlNumber: Int, completelyNew: Bool) {
        resetScore(ifNeeded: completelyNew)
        setLevel(with: lvlNumber)
        addMobsAndUpgrates()
        redrawScene?()
        startMobsMovement()
        doorEnterCount = 0
    }
    
    func initPlayers(names: [String]) {
        for name in names {
            addPlayer(name: name)
        }
    }
    
    func addPlayer(name: String) {
        players.append(Player(name: name, identifier: players.count, minesCount: 1, explosionPower: 1, position: 0, plantedMines: 0, isAlive: true))
    }
    
    func setDevices(names: [String]) {
        devices.removeAll()
        devices = names
    }
    
    func getPlayers(for map: inout String) {
        var i = 0
        var mapIndex = 0
        for char in map.characters {
            if char == "P" {
                if i >= players.count {
                    let index = map.characters.index(map.startIndex, offsetBy: mapIndex)
                    map.characters.remove(at: index)
                    map.characters.insert(" ", at: index)
                } else {
                    players[i].position = mapIndex
                    i += 1
                }
            }
            mapIndex += 1
        }
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
    
    //gets upgrades from connection
    func getUpgrades(upgradeTypes: [String]) {
        var i = 0, upgradeId = 0
        for char in tiles {
            if !char.isEmpty {
                if char[0] == "U" {
                    let upgradeType: UpgradeType
                    if upgradeId < upgradeTypes.count {
                        switch upgradeTypes[upgradeId] {
                        case "bomb": upgradeType = .anotherBomb
                        case "explosion": upgradeType = .strongerBomb
                        default: upgradeType = .anotherBomb
                        }
                        upgrades.append(Upgrade(position: i, type: upgradeType))
                    }
                    upgradeId += 1
                }
            }
            i += 1
        }
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
        tiles.removeAll()
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
    
    // if it's completely new game, reset score and create new player
    func resetScore(ifNeeded completelyNew: Bool) {
        if completelyNew {
            players.removeAll()
            initPlayers(names: devices)
            score = 0
            if !players.isEmpty {
                players[0].explosionPower = 1
                players[0].minesCount = 1
            }
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
        bombs.removeAll()
        if !players.isEmpty {
            players[0].isAlive = true
            players[0].plantedMines = 0
        }
    }
    
    // create new scene
    func setlevel(numberoflevel: Int) {
        width = numberoflevel == 0 ? 10 : 15
        var currentlevel = Levels().level(with: numberoflevel)
        getPlayers(for: &currentlevel)
        toTiles(scene: currentlevel)
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
