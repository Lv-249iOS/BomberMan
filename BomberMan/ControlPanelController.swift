//
//  ControlPanelController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class ControlPanelController: UIViewController {
 
    var onArrowTap: ((Direction)->())?
    var onBombTap: (()->())?
    // Send Arrow direction
    @IBAction func arrowTap(_ sender: UIButton) {
        if let arrowTag = Direction(rawValue: sender.tag) {
            onArrowTap?(arrowTag)
            print(arrowTag)
            Brain.shared.move(to: arrowTag, player: Player())
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationToMove), object: nil)
        }
    }
    
    @IBAction func setBomb(_ sender: UIButton) {
        onBombTap?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
