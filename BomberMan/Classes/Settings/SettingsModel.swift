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
    }
    
    var gameModeArray = [ //Need add images for game play
        #imageLiteral(resourceName: "settingsIconBomberMan"),
        #imageLiteral(resourceName: "backButtonForSettings")
        ]
    
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
}
