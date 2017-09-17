//
//  EventParser.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 9/15/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

class EventParser {
    
    func sendMoveEvent(name: String, direction: Direction) -> String {
        var str = name
        switch direction {
        case .bottom: str += " bottom"
        case .left: str += " left"
        case .right: str += " right"
        case .top: str += " top"
        }
        return str
    }
    
    func sendBombEvent(name: String) -> String {
        return name
    }
    
    func parseEvent(from string: String) -> (String?, Direction?) {
        let words = string.components(separatedBy: " ")
        if words.count == 1 {
            return (words[0], nil)
        }
        if words.count == 2 {
            var parsedDirection: Direction
            switch words[1] {
            case "top": parsedDirection = .top
            case "bottom": parsedDirection = .bottom
            case "left": parsedDirection = .left
            case "right": parsedDirection = .right
            default:
                return (nil, nil)
            }
            return (words[0], parsedDirection)
        }
        return (nil, nil)
    }
}
