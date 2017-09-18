//
//  ControlPanelController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class ControlPanelController: UIViewController {
 
    /// Closures for proccessing move and set bomb events
    var moveTo: ((Direction)->())?
    var setBomb: (()->())?
    
    @IBOutlet var controlPanelView: ControlPanelView!

    /// Set button state (true - enabled; false - disable)
    /// Precondition: gets boolean value (state) of control panel
    /// Postcondition: sets buttons on control panel to this state
    func setButtonState(isEnabled: Bool) {
        controlPanelView.setButtonState(isEnabled: isEnabled)
    }
    
    // Send event that on arrow taped and send arrow direction
    private func moveEvent(with direction: Direction) {
        moveTo?(direction)
    }
    
    // Send event that on bomb button taped
    private func setBombEvent() {
        setBomb?()
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
