//
//  ConnectionStructs.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/25/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

enum ConnectionWords: String {
    case bombUpgrade = "bomb"
    case explosionUpgrade = "explosion"
    case moveEvent = "move"
    case bombEvent = "bombs"
    case upgradesEvent = "upgrades"
    case topDirection = "top"
    case bottomDirection = "bottom"
    case leftDirection = "left"
    case rightDirection = "right"
    case separator = ","
}
