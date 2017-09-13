//
//  Brain+Timers.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/8/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { [weak self] _ in
            self?.gameEnd?(false)
        }
        
        timers.append(gameTimer)
    }
    
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
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            self?.explode(withOptionsOfPlayer: player, bomb: bomb)
            
            //needs to be finished
            self?.player.plantedMines -= 1
        }
        
        bomb.timer = timer
        bombs.append(bomb)
        timers.append(timer)
    }
    
    func startFireTimer(explosion: Explosion, position: Int) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.fadeFire(explosion: explosion, position: position)
        }
        
        timers.append(timer)
    }
    
    // Invalidates all timers in the game
    func invalidateTimers() {
        for timer in timers {
            timer.invalidate()
        }
        
        timers = []
    }
}
