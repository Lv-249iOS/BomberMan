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
    
    fileprivate var scene = Scene(data: Levels().level(with: 0), width: 10)
    private var cantGo = "WBXQ"
    private var mobCantGo = "WBXQUD"
    private var mobs: [Mob] = []
    
    var upgrades: [Upgrade] = []
    var player = Player(name: "Player", markForScene: "0", minesCount: 1, explosionPower: 1)
    var door = Door()
    var gameTimer: Timer!
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
    
    func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { [weak self] _ in
            self?.gameEnd?(false)
        }
        
        timers.append(gameTimer)
    }
    
    private func moveMobs() {
        func getDirectionPosition(mob: Mob) -> String.Index {
            let directionPosition: String.Index
            switch mob.direction {
            case .bottom: directionPosition = scene.data.characters.index(mob.position, offsetBy: scene.width)
            case .left: directionPosition = scene.data.characters.index(before: mob.position)
            case .right: directionPosition = scene.data.characters.index(after: mob.position)
            case .top: directionPosition = scene.data.index(mob.position, offsetBy: -scene.width)
            }
            return directionPosition
        }
        
        var i = 0
        var modifiedMobArray: [Mob] = []
        for var mob in mobs {
            if arc4random_uniform(7) == 5 {
                mob.direction = setMobDirection()
            }
            var directionPosition = getDirectionPosition(mob: mob)
            var loopsCount = 0
            var needToContinue = false
            while mobCantGo.characters.contains(scene.data[directionPosition]) {
                mob.direction = setMobDirection()
                directionPosition = getDirectionPosition(mob: mob)
                loopsCount += 1
                if loopsCount > 9 {
                    needToContinue = true
                    break
                }
            }
            if needToContinue {
                let modifiedMob = Mob(identifier: mob.identifier, animationSpeed: mob.animationSpeed, position: mob.position, direction: mob.direction)
                modifiedMobArray.append(modifiedMob)
                continue
            }
            scene.data.characters.remove(at: mob.position)
            scene.data.characters.insert(" ", at: mob.position)
            switch scene.data[directionPosition] {
            case "F":
                moveMob?(mob.direction, mob.identifier)
                killMob?(mob.identifier)
                score += 200
                refreshScore?(score)
                mobs.remove(at: i)
                needToContinue = true
            case player.markForScene:
                killHero?(0)
                moveMob?(mob.direction, mob.identifier)
                gameEnd?(false)
            default: moveMob?(mob.direction, mob.identifier)
            }
            if needToContinue {
                continue
            }
            scene.data.characters.remove(at: directionPosition)
            scene.data.characters.insert("M", at: directionPosition)
            mob.position = directionPosition
            i += 1
            let modifiedMob = Mob(identifier: mob.identifier, animationSpeed: mob.animationSpeed, position: mob.position, direction: mob.direction)
            modifiedMobArray.append(modifiedMob)
        }
        mobs.removeAll()
        for mob in modifiedMobArray {
            mobs.append(mob)
        }
    }
    
    private func setMobDirection() -> Direction {
        let randomDirection = arc4random_uniform(4) + 1
        if let direction = Direction(rawValue: Int(randomDirection)) {
            return direction
        }
        return Direction.bottom
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
        for _ in mobs {
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
    
    private func startMobsMovement() {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.moveMobs()
        }
        
        timers.append(timer)
        
    }
    
    private func startBombTimer(at position: String.Index, power: Int) {
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            self?.explode(at: position, power: power)
        }
        
        timers.append(timer)
        
    }
    
    private func startFireTimer(explosion: Explosion, position: String.Index) {
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
    private func blowFire(onPosition index: String.Index) -> (Bool, Bool, [Int]) {
        var canProceed = true
        var canBurn = true
        var killedPlayers: [Int] = []
        
        switch scene.data[index] {
        case "W": return (false, false, killedPlayers)
        case "B": canProceed = false
        case player.markForScene:
            gameEnd?(false)
            score -= 1000
            if score < 0 {
                score = 0
            }
            refreshScore?(score)
            if let intValue = Int(player.markForScene.description) {
                killedPlayers.append(intValue)
            }
        case "U":
            guard let upgradeIndex = getUpgradeIndex(atPosition: index) else { return (false, false, []) }
            if upgrades[upgradeIndex].health == 2 {
                upgrades[upgradeIndex].health = 1
                switch upgrades[upgradeIndex].type {
                case .anotherBomb:  showImage?(.anotherBomb, index)
                case .strongerBomb: showImage?(.strongerBomb, index)
                }
                canBurn = false
                canProceed = false
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
                        refreshScore?(score)
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
        return (canBurn, canProceed, killedPlayers)
    }
    
    private func explode(at position: String.Index, power: Int) {
        var killedPlayers: [Int] = []
        var explosion = Explosion.init()
        
        func explode(inDirection direction: Direction) -> Int {
            var strength = 0
            var offset = 0
            for i in 1...power  {
                switch direction {
                case .bottom: offset = i * scene.width
                case .left: offset = -i
                case .right: offset = i
                case .top: offset = -i * scene.width
                }
                let indexForFire = scene.data.characters.index(position, offsetBy: offset)
                let blowOptions: (canBurn: Bool, canProceed: Bool, killedPlayers: [Int]) = blowFire(onPosition: indexForFire)
                if blowOptions.canBurn {
                    strength += 1
                }
                if blowOptions.canProceed == false {
                    break
                }
                for player in blowOptions.killedPlayers {
                    killedPlayers.append(player)
                }
            }
            return strength
        }
        scene.data.characters.remove(at: position)
        scene.data.characters.insert("F", at: position)
        explosion.bottom = explode(inDirection: .bottom)
        explosion.left = explode(inDirection: .left)
        explosion.right = explode(inDirection: .right)
        explosion.top = explode(inDirection: .top)
        showFire?(explosion, position)
        
        for player in killedPlayers {
            killHero?(player)
        }
        startFireTimer(explosion: explosion, position: position)
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
}
