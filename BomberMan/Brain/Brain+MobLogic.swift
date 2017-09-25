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
            while mobCantGo(to: directionPosition) {
                mob.direction = setMobDirection()
                directionPosition = getDirectionPosition(mob: mob)
                loopsCount += 1
                if loopsCount > 9 {
                    needToContinue = true
                    break
                }
            }
            if needToContinue {
                let modifiedMob = Mob(identifier: mob.identifier, position: mob.position, direction: mob.direction)
                modifiedMobArray.append(modifiedMob)
                continue
            }
            if !tiles[mob.position].isEmpty {
                tiles[mob.position].removeLast()
            }
            let last = tiles[directionPosition].last ?? " "
            switch last {
            case "F":
                moveMob?(mob.direction, mob.identifier)
                killMob?(mob.identifier, false)
                score += ScoreBoosts.mobKill.rawValue
                refreshScore?(score)
                mobs.remove(at: i)
                needToContinue = true
            case "P":
                var j = 0
                score += ScoreBoosts.death.rawValue
                if score < 0 {
                    score = 0
                }
                for player in players {
                    if player.position == directionPosition {
                        killHero?(player.identifier, false)
                        players[j].isAlive = false
                        moveMob?(mob.direction, mob.identifier)
                        gameEnd?(false)
                    }
                    j += 1
                }
            default:
                moveMob?(mob.direction, mob.identifier)
            }
            if needToContinue {
                continue
            }
            tiles[directionPosition].append("M")
            mob.position = directionPosition
            i += 1
            let modifiedMob = Mob(identifier: mob.identifier, position: mob.position, direction: mob.direction)
            modifiedMobArray.append(modifiedMob)
        }
        mobs.removeAll()
        for mob in modifiedMobArray {
            mobs.append(mob)
        }
    }
    
    func mobCantGo(to directionPosition: Int) -> Bool {
        for char in tiles[directionPosition].reversed() {
            if mobCantGo.characters.contains(char) {
                return true
            }
        }
        return false
    }
    
    func getDirectionPosition(mob: Mob) -> Int {
        switch mob.direction {
        case .bottom: return mob.position + width
        case .left: return mob.position - 1
        case .right: return mob.position + 1
        case .top: return mob.position - width
        }
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
    
    func getMobIndex(atPosition position: Int) -> [Mob]? {
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
