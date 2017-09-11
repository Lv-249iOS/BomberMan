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
    
    // Invalidates all timers in the game
    func invalidateTimers() {
        for timer in timers {
            timer.invalidate()
        }
        
        timers = []
    }
}
