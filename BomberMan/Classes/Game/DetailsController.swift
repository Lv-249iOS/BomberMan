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
    
    var isPause: Bool = false
    
    @IBOutlet var detailsView: SingleDetailsView!
    
    // Shows current time usage in label
    func present(time: String) { // Change to Timer
        detailsView.timeLabel.text = time
    }
    
    // Shows current score in label
    func present(score: Double) {
        detailsView.scoreLabel.text = "\(score)"
    }
    
    // Sends event that pause taped
    func pauseTap() {
        isPause = isPause == false ? true : false
        onPauseTap?(isPause)
    }
    
    // Sends event that home taped
    func homeTap() {
        onHomeTap?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsView.onHomeButtTap = { [weak self] in
            self?.homeTap()
        }
        
        detailsView.onPauseButtTap = {[weak self] in
            self?.pauseTap()
        }
        // Do any additional setup after loading the view.
    }
}
