//
//  EventParser.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/15/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

class EventParser {
    
    func stringMoveEvent(name: String, direction: Direction) -> String {
        var str = ConnectionWords.moveEvent.rawValue + ConnectionWords.separator.rawValue + name
        switch direction {
        case .bottom: str += ConnectionWords.separator.rawValue + ConnectionWords.bottomDirection.rawValue
        case .left: str += ConnectionWords.separator.rawValue + ConnectionWords.leftDirection.rawValue
        case .right: str += ConnectionWords.separator.rawValue + ConnectionWords.rightDirection.rawValue
        case .top: str += ConnectionWords.separator.rawValue + ConnectionWords.topDirection.rawValue
        }
        return str
    }
    
    func stringBombEvent(name: String) -> String {
        return ConnectionWords.bombEvent.rawValue + ConnectionWords.separator.rawValue + name
    }
    
    func stringUpgrades(upgrades: [Upgrade]) -> String {
        var str = ConnectionWords.upgradesEvent.rawValue + ConnectionWords.separator.rawValue
        for upgrade in upgrades {
            switch upgrade.type {
            case .anotherBomb: str += ConnectionWords.bombUpgrade.rawValue + ConnectionWords.separator.rawValue
            case .strongerBomb: str += ConnectionWords.explosionUpgrade.rawValue + ConnectionWords.separator.rawValue
            }
        }
        str.characters.removeLast()
        return str
    }
    
    func parseEvent(from string: String) -> (String?, Direction?, [String]?) {
        var words = string.components(separatedBy: ConnectionWords.separator.rawValue)
        let type = words.removeFirst()
        switch type {
        case ConnectionWords.moveEvent.rawValue:
            var parsedDirection: Direction
            switch words[1] {
            case ConnectionWords.topDirection.rawValue: parsedDirection = .top
            case ConnectionWords.bottomDirection.rawValue: parsedDirection = .bottom
            case ConnectionWords.leftDirection.rawValue: parsedDirection = .left
            case ConnectionWords.rightDirection.rawValue: parsedDirection = .right
            default:
                return (nil, nil, nil)
            }
            return (words[0], parsedDirection, nil)
        case ConnectionWords.bombEvent.rawValue:
            return (words[0], nil, nil)
        case ConnectionWords.upgradesEvent.rawValue:
            var result: [String] = []
            for word in words {
                result.append(word)
            }
            return(nil, nil, result)
        default: return(nil, nil, nil)
        }
    }
}
