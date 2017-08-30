//
//  ViewController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/25/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    @IBOutlet weak var soundButton: UIButton!
    
    @IBAction func onSoundTap(_ sender: UIButton) {
        if let soundState = UserDefaults.standard.value(forKey: "soundState") as? Bool {
            let img = soundState != true ? #imageLiteral(resourceName: "soundOn") : #imageLiteral(resourceName: "soundOff")
            
            soundButton.setImage(img, for: .normal)
            UserDefaults.standard.set(!soundState, forKey: "soundState")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "soundState") as? Bool == nil {
            UserDefaults.standard.set(false, forKey: "soundState")
        }
    }
}

