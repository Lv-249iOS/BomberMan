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
    
    private var initialScene = Scene.init(data: "WWWWWWWWWWW  0     WWM       WW        WW  B BBB WW  BMB   WW  BBBBB WW    B B WW  BBBMB WWWWWWWWWWW",
                                          width: 10)
    private var scene = Scene.init(data: "WWWWWWWWWWW  0     WWM       WW        WW  B BBB WW  BMB   WW  BBBBB WW    B B WW  BBBMB WWWWWWWWWWW", width: 10)
    private var cantGo = "WBXQ"
    private var mobs: [Mob] = []
    private var upgrades: [Upgrade] = []
    
    var player = Player.init(name: "Player", markForScene: "0", minesCount: 1, explosionPower: 1)
    var door = Door.init()
    var gameTimer: Timer!
    var score = 0
    
    var showFire: ((Explosion, String.Index)->())?
    var move: ((Direction, Int)->())?
    var plantBomb: ((Int)->())?
    var showImage: ((DoubleHealthThings, String.Index)->())?
    var redrawScene: (()->())?
    var killHero: ((Int)->())?
    var killMob: ((Int)->())?
    var moveMob: ((Direction, Int)->())?
    var gameEnd: ((Bool)->())?
    
    //used at the beginning of the game
    func initializeGame(withScene: Scene) {
        scene = initialScene
        door.health = 2
        mobs.removeAll()
        upgrades.removeAll()
        score = 0
        
        var i = 0
        for char in scene.data.characters {
            let index = scene.data.characters.index(scene.data.startIndex, offsetBy: i)
            switch char {
            case "M":
                let identifier = scene.data.distance(from: scene.data.startIndex, to: index)
                let mob = Mob.init(identifier: identifier, animationSpeed: 1, position: index, direction: setMobDirection())
                mobs.append(mob)
            case "U":
                let randomType = arc4random_uniform(1)
                guard let type = UpgradeType(rawValue: Int(randomType)) else { return }
                let upgrade = Upgrade.init(health: 2, position: index, type: type)
                upgrades.append(upgrade)
            default: break
            }
            i += 1
        }
        startMobsMovement()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: false, block: { [weak self] _ in
            self?.gameEnd?(false)
        })
    }
    
    private func moveMobs() {
        var i = 0
        for var mob in mobs {
            var directionPosition: String.Index
            switch mob.direction {
                case .bottom: directionPosition = scene.data.characters.index(mob.position, offsetBy: scene.width)
                case .left: directionPosition = scene.data.characters.index(before: mob.position)
                case .right: directionPosition = scene.data.characters.index(after: mob.position)
                case .top: directionPosition = scene.data.index(mob.position, offsetBy: -scene.width)
            }
            while !cantGo.characters.contains(scene.data[directionPosition]), scene.data[directionPosition] != "U", scene.data[directionPosition] != "D" {
                mob.direction = setMobDirection()
                switch mob.direction {
                case .bottom: directionPosition = scene.data.characters.index(mob.position, offsetBy: scene.width)
                case .left: directionPosition = scene.data.characters.index(before: mob.position)
                case .right: directionPosition = scene.data.characters.index(after: mob.position)
                case .top: directionPosition = scene.data.index(mob.position, offsetBy: -scene.width)
                }
            }
            scene.data.characters.remove(at: mob.position)
            scene.data.characters.insert(" ", at: mob.position)
            switch scene.data[directionPosition] {
            case "F":
                //move on map
                killMob?(mob.identifier)
                score += 200
                mobs.remove(at: i)
                i -= 1
            case player.markForScene:
                killHero?(0)
                //move on map
                gameEnd?(false)
            default: break
                //move on map
            }
            scene.data.characters.remove(at: directionPosition)
            scene.data.characters.insert("M", at: directionPosition)
            i += 1
        }
    }
    
    private func setMobDirection() -> Direction {
        let randomDirection = arc4random_uniform(3) + 1
        if let direction = Direction(rawValue: Int(randomDirection)) {
            return direction
        }
        return Direction.bottom
    }

    func appendScene(withWidth width: Int, data: String) {
        initialScene.data = data
        initialScene.width = width
    }
    
    private func entryPointsCount(for testStr: String, char: Character) -> Int {
        var count = 0
        for c in testStr.characters {
            if c == char {
                count += 1
            }
        }
        return count
    }
    
    private func getUpgradeIndex(atPosition position: String.Index) -> Int? {
        var i = 0
        for item in upgrades {
            if item.position == position {
                return i
            }
            i += 1
        }
        return nil
    }
    
    private func getMobIndex(atPosition position: String.Index) -> [Mob]? {
        var result: [Mob] = []
        for mob in mobs {
            if mob.position == position {
                result.append(mob)
            }
        }
        if result.count == 0 {
            return nil
        }
        return result
    }
    
    private func getMobIndexInPrivateArray(mob: Mob) -> Int? {
        var i = 0
        for mob in mobs {
            if mob.identifier == mobs[i].identifier {
                return i
            }
            i += 1
        }
        return nil
    }
    
    func shareScene() -> Scene {
        return scene
    }
    
    //return mob identifiers for GameMap
    func shareMobs() -> [Int] {
        var identifiers: [Int] = []
        for mob in mobs {
            identifiers.append(mob.identifier)
        }
        return identifiers
    }

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
                    } else {
                        canGo = false
                    }
                case "D":
                    if door.health == 2 {
                        canGo = false
                    } else {
                        if let intValue = Int(player.markForScene.description) {
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
//                    return
                }
            }
        }
//        return
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
    
    private func startMobsMovement() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.moveMobs()
        }
    }
    
    private func startBombTimer(at position: String.Index, power: Int) {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
            self?.explode(at: position, power: power)
        })
    }
    
    private func startFireTimer(explosion: Explosion, position: String.Index) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.fadeFire(explosion: explosion, position: position)
        }
    }
    
    private func fadeFire(explosion: Explosion, position: String.Index) {
        scene.data.remove(at: position)
        scene.data.insert(" ", at: position)
        for i in 0..<explosion.bottom  {
            let indexForFire = scene.data.characters.index(position, offsetBy: (i+1) * scene.width)
            scene.data.remove(at: indexForFire)
            scene.data.insert(" ", at: indexForFire)
        }
        for i in 0..<explosion.top  {
            let indexForFire = scene.data.characters.index(position, offsetBy: -(i+1) * scene.width)
            scene.data.remove(at: indexForFire)
            scene.data.insert(" ", at: indexForFire)
        }
        for i in 0..<explosion.right  {
            let indexForFire = scene.data.characters.index(position, offsetBy: (i+1))
            scene.data.remove(at: indexForFire)
            scene.data.insert(" ", at: indexForFire)
        }
        for i in 0..<explosion.left  {
            let indexForFire = scene.data.characters.index(position, offsetBy: -(i+1))
            scene.data.remove(at: indexForFire)
            scene.data.insert(" ", at: indexForFire)
        }
        redrawScene?()
    }
    
    //sets fire on position in scene and returns true if nothing stops it
    private func blowFire(onPosition index: String.Index) -> (Bool, Bool) {
        var canProceed = true
        var canBurn = true
        
        switch scene.data[index] {
        case "W": return (false, false)
        case "B": canProceed = false
        case player.markForScene: gameEnd?(false)
        case "U":
            guard let upgradeIndex = getUpgradeIndex(atPosition: index) else { return (false, false) }
            if upgrades[upgradeIndex].health == 2 {
                upgrades[upgradeIndex].health = 1
                switch upgrades[upgradeIndex].type {
                case .anotherBomb:  showImage?(.anotherBomb, index)
                case .strongerBomb: showImage?(.strongerBomb, index)
                }
                canBurn = false
            }
        case "D":
            if door.health == 2 {
                showImage?(.door, index)
                door.health = 1
            }
            canBurn = false
            canProceed = false
        case "M":
            if let mobsAtCurrentPosition = getMobIndex(atPosition: index) {
                for mob in mobsAtCurrentPosition {
                    if let indexInPrivateArray = getMobIndexInPrivateArray(mob: mob) {
                        mobs.remove(at: indexInPrivateArray)
                        killMob?(mob.identifier)
                        score += 200
                    }
                }
            }
        default:
            break
        }
        if canBurn {
            scene.data.remove(at: index)
            scene.data.insert("F", at: index)
        }
        return (canBurn, canProceed)
    }
    
    private func explode(at position: String.Index, power: Int) {
        var explosion = Explosion.init()
        scene.data.characters.remove(at: position)
        scene.data.characters.insert("F", at: position)
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: i * scene.width)
            let blowOptions: (canBurn: Bool, canProceed: Bool) = blowFire(onPosition: indexForFire)
            if blowOptions.canBurn {
                explosion.bottom += 1
            }
            if blowOptions.canProceed == false {
                break
            }
        }
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: -i * scene.width)
            let blowOptions: (canBurn: Bool, canProceed: Bool) = blowFire(onPosition: indexForFire)
            if blowOptions.canBurn {
                explosion.top += 1
            }
            if blowOptions.canProceed == false {
                break
            }
        }
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: i)
            let blowOptions: (canBurn: Bool, canProceed: Bool) = blowFire(onPosition: indexForFire)
            if blowOptions.canBurn {
                explosion.right += 1
            }
            if blowOptions.canProceed == false {
                break
            }
        }
        for i in 1...power  {
            let indexForFire = scene.data.characters.index(position, offsetBy: -i)
            let blowOptions: (canBurn: Bool, canProceed: Bool) = blowFire(onPosition: indexForFire)
            if blowOptions.canBurn {
                explosion.left += 1
            }
            if blowOptions.canProceed == false {
                break
            }
        }
        showFire?(explosion, position)
        startFireTimer(explosion: explosion, position: position)
    }
}
