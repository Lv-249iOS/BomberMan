//
//  MultiplayerDetailsController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/15/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class MultiplayerDetailsController: UIViewController {
    var onHomeTap: (()->())?
    var playersNames: [String]?
    
    @IBOutlet var detailsView: MultiDetailsView!
    
    // Sends event that home taped
    func homeTap() {
        // умертвити гравця
        onHomeTap?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNames()
        detailsView.onHomeButtTap = { [weak self] in
            self?.homeTap()
        }
    }
    
    func setNames() {
        playersNames = ["aaaaaaa", "vvvvvv", "ssssss", "dddddd"]
        if let names = playersNames {
            detailsView.setNames(names: names)
        }
    }
}
