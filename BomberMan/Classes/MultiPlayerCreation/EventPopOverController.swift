//
//  EventPopOverController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/5/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class EventPopOverController: UIViewController {
    
    @IBOutlet var popOverView: EventPopOverView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popOverView.onDontShowButtTap = { [weak self] in
            self?.onNeverShowAgainTap()
        }
    }
    
    func onNeverShowAgainTap() {

    }
}
