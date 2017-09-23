//
//  SettingsModel.swift
//  BomberMan
//
//  Created by Yevhen Roman on 9/22/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
import UIKit

class SettingsModel {
    
    static let shared = SettingsModel()
    
    enum PathForKey: String {
        case currentPageOfImage = "currentPageOfImage"
        case controlMode = "controlMode"
    }
    
    var gameModeArray = [ //Need add images for game play
        #imageLiteral(resourceName: "bom1"),
        #imageLiteral(resourceName: "bom2"),
        #imageLiteral(resourceName: "bom3"),
        #imageLiteral(resourceName: "bom4")
    ]
    
    var pickerModeArray = ["Buttons", "Buttons and gestures"]
    
    var currentPage: Int {
        get {
            if let value = UserDefaults.standard.value(forKey: PathForKey.currentPageOfImage.rawValue) as? Int {
                return value
            } else {
                return 0
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PathForKey.currentPageOfImage.rawValue)
        }
    }
    
    var currentBackgroundImage: UIImage {
        return gameModeArray[currentPage]
    }
    
    var currentMode: String {
        get {
            if let value = UserDefaults.standard.string(forKey: PathForKey.controlMode.rawValue) {
                return value
            } else {
                return "Buttons"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PathForKey.controlMode.rawValue)
        }
    }
}