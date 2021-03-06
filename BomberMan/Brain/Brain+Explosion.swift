//
//  Brain+Explosion.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/7/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    func explode(withOptionsOfPlayer player: Player, bomb: Bomb) {
        var killedPlayers: [Int] = []
        var explodedBoxes: [Int] = []
        var explosion = Explosion.init()
        
        //blows fire on tiles and returns how far goes the fire
        func explode(inDirection direction: Direction) -> Int {
            var strength = 0
            var offset = 0
            for i in 1...player.explosionPower  {
                switch direction {
                case .bottom: offset = i * width
                case .left: offset = -i
                case .right: offset = i
                case .top: offset = -i * width
                }
                let blowOptions: (canBurn: Bool, canProceed: Bool, killedPlayers: [Int], explodedBoxes: [Int]) = blowFire(onPosition: player.position + offset)
                if blowOptions.canBurn {
                    strength += 1
                }
                for player in blowOptions.killedPlayers {
                    killedPlayers.append(player)
                }
                for box in blowOptions.explodedBoxes {
                    explodedBoxes.append(box)
                }
                if blowOptions.canProceed == false {
                    break
                }
            }
            return strength
        }
        
        tiles[bomb.position].remove(at: tiles[bomb.position].index(of: "X") ?? 0)
        let index = getBombIndex(at: bomb.position)
        if index >= 0 {
            bombs.remove(at: index)
        }
        let blowOptions: (canBurn: Bool, canProceed: Bool, killedPlayers: [Int], explodedBoxes: [Int]) = blowFire(onPosition: player.position)
        for player in blowOptions.killedPlayers {
            killedPlayers.append(player)
        }
        for box in blowOptions.explodedBoxes {
            explodedBoxes.append(box)
        }
        explosion.bottom = explode(inDirection: .bottom)
        explosion.left = explode(inDirection: .left)
        explosion.right = explode(inDirection: .right)
        explosion.top = explode(inDirection: .top)
        DispatchQueue.main.async { [weak self] in
            self?.showFire?(explosion, player.position)
        }
        for player in killedPlayers {
            DispatchQueue.main.async { [weak self] in
                self?.killHero?(player, false)
            }
        }
        for box in explodedBoxes {
            DispatchQueue.main.async { [weak self] in
                self?.boxExplode?(box)
            }
        }
        
        startFireTimer(explosion: explosion, position: bomb.position)
    }
    
    //returns -1 if no bomb found
    func getBombIndex(at position: Int) -> Int {
        var i = 0
        for bomb in bombs {
            if bomb.position == position {
                return i
            }
            i += 1
        }
        return -1
    }
    
    //sets fire on position in scene if canBurn is true and returns canProceed true if nothing stops it, also returns identifiers for killedPlayers
    func blowFire(onPosition index: Int) -> (Bool, Bool, [Int], [Int]) {
        var canProceed = true
        var canBurn = true
        var killedPlayers: [Int] = []
        var explodedBoxes: [Int] = []
        
        for char in tiles[index].reversed() {
            var needToBreak = false
            
            switch char {
            case "W": return (false, false, killedPlayers, explodedBoxes)
            case "B":
                needToBreak = true
                canProceed = false
                tiles[index].removeLast()
                if !tiles[index].isEmpty {
                    canBurn = false
                }
                explodedBoxes.append(index)
            ///
            case "P":
                var i = 0
                for player in players {
                    if players.count > i, player.position == index {
                        players[i].isAlive = false
                        if isSingleGame {
                            gameEnd?(false)
                            score += ScoreBoosts.death.rawValue
                            if score < 0 {
                                score = 0
                            }
                            refreshScore?(score)
                        }
                        killedPlayers.append(player.identifier)
                        if !tiles[index].isEmpty{
                            tiles[index].removeLast()
                        }
                    }
                    i += 1
                }
                if alivePlayersCount() <= 1, !isSingleGame {
                    invalidateTimers()
                    endMultiplayer(withTimeInterval: 4)
                }
            case "U":
                tiles[index].removeLast()
            case "D":
                canBurn = false
                canProceed = false
            case "M":
                if let mobAtCurrentPosition = getMobIndex(atPosition: index) {
                    if let indexInPrivateArray = getMobIndexInPrivateArray(mob: mobAtCurrentPosition[0]) {
                        mobs.remove(at: indexInPrivateArray)
                        DispatchQueue.main.async { [weak self] in
                            self?.killMob?(mobAtCurrentPosition[0].identifier, false)
                        }
                        score += ScoreBoosts.mobKill.rawValue
                        refreshScore?(score)
                    }
                }
                tiles[index].removeLast()
            case "X":
                bombs[getBombIndex(at: index)].timer?.fire()
            default:
                break
            }
            if needToBreak {
                break
            }
        }
        if canBurn {
            tiles[index].append("F")
        }
        return (canBurn, canProceed, killedPlayers, explodedBoxes)
    }
    
    func fadeFire(explosion: Explosion, position: Int) {
        if tiles.count <= position || position < 0 { return }
        tiles[position].removeAll()
        for i in 0..<explosion.bottom  {
            let indexForFire = position + (i+1) * width
            tiles[indexForFire].removeAll()
        }
        for i in 0..<explosion.top  {
            let indexForFire = position - (i+1) * width
            tiles[indexForFire].removeAll()
        }
        for i in 0..<explosion.right  {
            let indexForFire = position + (i+1)
            tiles[indexForFire].removeAll()
        }
        for i in 0..<explosion.left  {
            let indexForFire = position - (i+1)
            tiles[indexForFire].removeAll()
        }
        
        redrawScene?()
    }
}
