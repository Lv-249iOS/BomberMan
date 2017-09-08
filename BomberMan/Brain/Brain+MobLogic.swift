//
//  Brain+MobLogic.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/7/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    func moveMobs() {
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
    
    func setMobDirection() -> Direction {
        let randomDirection = arc4random_uniform(4) + 1
        if let direction = Direction(rawValue: Int(randomDirection)) {
            return direction
        }
        return Direction.bottom
    }
    
    //return mob identifiers for GameMap
    func shareMobs() -> [Int] {
        var identifiers: [Int] = []
        for mob in mobs {
            identifiers.append(mob.identifier)
        }
        return identifiers
    }
    
    func getMobIndexInPrivateArray(mob: Mob) -> Int? {
        var i = 0
        for _ in mobs {
            if mob.identifier == mobs[i].identifier {
                return i
            }
            i += 1
        }
        return nil
    }
    
    func getMobIndex(atPosition position: String.Index) -> [Mob]? {
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
}
