//
//  DetailsController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class SingleplayerDetailsController: UIViewController {
    
    // Closures for proccessing pause, back to home and time over events
    var onPauseTap: ((Bool)->())?
    var onHomeTap: (()->())?
    var timeOver: (()->())?
    
    var gameTimer: Timer!
    var isPause: Bool = false
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
