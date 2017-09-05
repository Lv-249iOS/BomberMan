//
//  DetailsController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {
    
    var onPauseTap: ((Bool)->())?
    var onHomeTap: (()->())?
    var timeOver: (()->())?
    
    var isPause: Bool = false
    var timer: Timer!
    var isTimerRunning = false
    
    @IBOutlet var detailsView: SingleDetailsView!
    
    // Shows current time usage in label
    func present(time: String) {
        detailsView.timeLabel.text = time
    }
    
    // Shows current score in label
    func present(score: Double) {
        detailsView.scoreLabel.text = "\(score)"
    }
    
    // Sends event that pause taped
    func pauseTap() {
        isPause = isPause == false ? true : false
        stopTimer()
        onPauseTap?(isPause)
    }
    
    // Sends event that home taped
    func homeTap() {
        stopTimer()
        onHomeTap?()
    }
    
    // Starting running timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(presentTimer)),
                                     userInfo: nil,
                                     repeats: true)
        isTimerRunning = true
    }
    
    // Methods for timer invalidation
    func stopTimer() {
        timer.invalidate()
        isTimerRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        detailsView.scoreLabel.text = "0.0"
        detailsView.timeLabel.text = "00:00"

        Brain.shared.currentTime = Brain.shared.timeLimit
        
    }
    
    // Stop timer if it's running now and pause's switched on
    func changeTimerState() {
        isTimerRunning && isPause ? stopTimer() : runTimer()
    }
    
    // Updates timer and shows in label
    func presentTimer() {
        if Brain.shared.currentTime < 1 {
            timer.invalidate()
            timeOver?()
        } else {
            Brain.shared.currentTime -= 1
            present(time: TimeInterval.toString(Brain.shared.currentTime))
        }
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
