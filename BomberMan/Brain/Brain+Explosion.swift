//
//  Brain+Explosion.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/7/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    func explode(at position: String.Index, power: Int) {
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
    
    //sets fire on position in scene and returns true if nothing stops it
    func blowFire(onPosition index: String.Index) -> (Bool, Bool, [Int]) {
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
    
    func fadeFire(explosion: Explosion, position: String.Index) {
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
}
