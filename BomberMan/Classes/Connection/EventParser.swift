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
        var str = "move " + name
        switch direction {
        case .bottom: str += " bottom"
        case .left: str += " left"
        case .right: str += " right"
        case .top: str += " top"
        }
        return str
    }
    
    func stringBombEvent(name: String) -> String {
        return "bomb " + name
    }
    
    func stringUpgrades(upgrades: [Upgrade]) -> String {
        var str = "upgrades "
        for upgrade in upgrades {
            switch upgrade.type {
            case .anotherBomb: str += "bomb "
            case .strongerBomb: str += "explosion "
            }
        }
        str.characters.removeLast()
        return str
    }
    
    func parseEvent(from string: String) -> (String?, Direction?, [String]?) {
        var words = string.components(separatedBy: " ")
        let type = words.removeFirst()
        switch type {
        case "move":
            var parsedDirection: Direction
            switch words[1] {
            case "top": parsedDirection = .top
            case "bottom": parsedDirection = .bottom
            case "left": parsedDirection = .left
            case "right": parsedDirection = .right
            default:
                return (nil, nil, nil)
            }
            return (words[0], parsedDirection, nil)
        case "bomb":
            return (words[0], nil, nil)
        case "upgrades":
            var result: [String] = []
            for word in words {
                result.append(word)
            }
            return(nil, nil, result)
        default: return(nil, nil, nil)
        }
    }
}
