//
//  ControlPanelController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class ControlPanelController: UIViewController {
 
    var moveTo: ((Direction)->())?
    var setBomb: (()->())?
    
    @IBOutlet var controlPanelView: ControlPanelView!
    
    // Send Arrow direction
    func moveEvent(with direction: Direction) {
        // send event
        moveTo?(direction)
    }
    
    func setBombEvent() {
        // send event
        setBomb?()
    }

    func setButtonState(isEnabled: Bool) {
        controlPanelView.setButtonState(isEnabled: isEnabled)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlPanelView.onArrowTap = { [weak self] direction in
            self?.moveEvent(with: direction)
        }
        
        controlPanelView.onBombTap = { [weak self] in
            self?.setBombEvent()
        }
    }
}
