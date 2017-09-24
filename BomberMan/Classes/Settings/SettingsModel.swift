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
        case currentCharacterImage = "currentCharacterImage"
        case currentPlayMode = "currentPlayMode"
    }
    var characterImagesArray = [ #imageLiteral(resourceName: "bom1"),#imageLiteral(resourceName: "bom2"),#imageLiteral(resourceName: "bom3"),#imageLiteral(resourceName: "bom4")]
    var gameModeArray = ["Only buttons","Buttons and gestures"]
    
    var currentCharacterImage: Int {
        get {
            if let value = UserDefaults.standard.value(forKey: PathForKey.currentCharacterImage.rawValue) as? Int {
                return value
            } else {
                return 0
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PathForKey.currentCharacterImage.rawValue)
        }
    }
    var currentPlayerMode: Int {
        get {
            if let value = UserDefaults.standard.value(forKey: PathForKey.currentPlayMode.rawValue) as? Int {
                return value
            } else {
                return 0
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PathForKey.currentPlayMode.rawValue)
        }
    }
    
}
