//
//  DetailsController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {
    
    var onPauseTap: (()->())?
    var onHomeTap: (()->())?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // Shows current time usage in label
    func present(time: String) { // Change to Timer
        timeLabel.text = time
    }
    
    // Shows current score in label
    func present(score: Double) {
        scoreLabel.text = "\(score)"
    }
    
    // Sends event that pause taped
    @IBAction func pauseTap(_ sender: UIButton) {
        onPauseTap?()
    }
    
    // Sends event that home taped
    @IBAction func homeTap(_ sender: UIButton) {
        onHomeTap?()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
