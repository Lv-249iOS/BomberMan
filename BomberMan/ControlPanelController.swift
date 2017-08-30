//
//  ControlPanelController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

enum ArrowDirection: Int {
    case up = 1
    case left = 2
    case right = 3
    case down = 4
}

class ControlPanelController: UIViewController {
    var onArrowTap: ((ArrowDirection)->())?
    var onBombTap: (()->())?
    
    // Sends arrow direction
    @IBAction func arrowTap(_ sender: UIButton) {
        if let arrowTag = ArrowDirection(rawValue: sender.tag) {
            onArrowTap?(arrowTag)
        }
    }
    
    // Sends event that bomb is ready to be set
    @IBAction func setBomb(_ sender: UIButton) {
        onBombTap?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
