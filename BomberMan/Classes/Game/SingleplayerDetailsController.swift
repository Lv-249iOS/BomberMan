//
//  DetailsController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

protocol GameTimer {
    
    func runTimer()
    func stopTimer()
    func resetTimer()
    func changeTimerState()
    func presentTimer()
}

class SingleplayerDetailsController: UIViewController {
    
    var onPauseTap: ((Bool)->())?
    var onHomeTap: (()->())?
    var timeOver: (()->())?
    
    var isPause: Bool = false
    var timer: Timer!
    var isTimerRunning = false
    
    @IBOutlet var detailsView: SingleDetailsView!
    
    func present(time: String) {
        detailsView.timeLabel.text = time
    }
    
    func present(score: Double) {
        detailsView.scoreLabel.text = "\(score)"
    }
    
    // Precondition: calls when on pause tap
    // Postcondition: stop timer and send event that on pause taped
    private func pauseTap() {
        isPause = isPause == false ? true : false
        stopTimer()
        onPauseTap?(isPause)
    }
    
    // Precondition: calls when on home tap
    // Postcondition: stop timer and send event that on back to home taped
    private func homeTap() {
        stopTimer()
        onHomeTap?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTimer()
        
        detailsView.onHomeButtTap = { [weak self] in
            self?.homeTap()
        }
        
        detailsView.onPauseButtTap = {[weak self] in
            self?.pauseTap()
        }
    }
}

extension SingleplayerDetailsController: GameTimer {
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(presentTimer)),
                                     userInfo: nil,
                                     repeats: true)
        isTimerRunning = true
    }
    
    func stopTimer() {
        timer.invalidate()
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
            timer.invalidate()
            timeOver?()
        } else {
            Brain.shared.currentTime -= 1
            present(time: TimeInterval.toString(Brain.shared.currentTime))
        }
    }
    
}


