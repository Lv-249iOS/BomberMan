//
//  SingeDetailsController+GameTimerProtocol.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/15/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension SingleplayerDetailsController: GameTimer {
    
    func runTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: (#selector(presentTimer)),
                                         userInfo: nil,
                                         repeats: true)
        isTimerRunning = true
    }
    
    func stopTimer() {
        gameTimer.invalidate()
        isTimerRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        detailsView.scoreLabel.text = "0.0"
        detailsView.timeLabel.text = "00:00"
    }
    
    /// Changes stop or run timer accordingly to pause and timer state
    /// Timer will be stoped if timer is running and pause is taped
    /// In another case timer will be run
    func changeTimerState() {
        isTimerRunning && isPause ? stopTimer() : runTimer()
    }
    
    /// Used by selector for scheduled game timer
    /// Present time in label in format 00:00
    /// When time is going to be out of range timer will be stoped and
    /// timeOver event will be sent
    func presentTimer() {
        if Brain.shared.currentTime < 1 {
            gameTimer.invalidate()
            timeOver?(true)
        } else {
            Brain.shared.currentTime -= 1
            present(time: TimeInterval.toString(Brain.shared.currentTime))
        }
    }
}


