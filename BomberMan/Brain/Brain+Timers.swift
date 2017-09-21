//
//  Brain+Timers.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/8/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    func startMobsMovement() {
        mobsTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.moveMobs()
        }
        
        timers.append(mobsTimer)
    }
    
    func stopMobsMovement() {
        mobsTimer.invalidate()
    }
    
    func startBombTimer(withOptionsOfPlayer player: Player) {
        var bomb = Bomb(owner: player, power: player.explosionPower, timer: nil, position: player.position)
        DispatchQueue.main.async { [weak self] in
            let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
                self?.explode(withOptionsOfPlayer: player, bomb: bomb)
                
                var i = 0
                let players = self?.players ?? []
                for guy in players {
                    if guy.identifier == player.identifier {
                        self?.players[i].plantedMines -= 1
                    }
                    i += 1
                }
            }
            
            bomb.timer = timer
            self?.bombs.append(bomb)
            self?.timers.append(timer)
        }
    }
    
    func startFireTimer(explosion: Explosion, position: Int) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.fadeFire(explosion: explosion, position: position)
            }
            
            let isSingleGame = self?.isSingleGame ?? true
            let alivePlayersCount = self?.alivePlayersCount() ?? 0
            if !isSingleGame, alivePlayersCount <= 1 {
                self?.multiplayerEnd?(self!.getWinner())
            }
        }
        
        timers.append(timer)
    }
    
    // Invalidates all timers in the game
    func invalidateTimers() {
        currentTime = timeLimit
        for timer in timers {
            timer.invalidate()
        }
        
        timers = []
    }
}
