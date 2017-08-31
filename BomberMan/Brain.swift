//
//  Explosion.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 8/26/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

class Brain {
    static let shared = Brain()
    var sceneData: String = "WWWWWWWWWWW  P     WW        WW        WW  B BBB WW  B B   WW  BBBBB WW    B B WW  BBB B WWWWWWWWWWW"
    private var sceneWidth = 10
    
    func appendScene(with width: Int, scene: String) {
        sceneData = scene
        sceneWidth = width
    }

    func move(to direction: Direction, player: Player) -> Bool {
        if let playerPosition = sceneData.characters.index(of: "P") {
            switch direction {
            case .bottom:
                if sceneData[sceneData.characters.index(playerPosition, offsetBy: sceneWidth)] == " " {
                    sceneData.characters.remove(at: playerPosition)
                    sceneData.characters.insert(" ", at: playerPosition)
                    sceneData.characters.remove(at: sceneData.index(playerPosition, offsetBy: sceneWidth))
                    sceneData.characters.insert("P", at: sceneData.index(playerPosition, offsetBy: sceneWidth))
                    return true
                }
            case .left:
                if sceneData[sceneData.characters.index(before: playerPosition)] == " " {
                    sceneData.characters.remove(at: playerPosition)
                    sceneData.characters.insert(" ", at: playerPosition)
                    sceneData.characters.remove(at: sceneData.index(before: playerPosition))
                    sceneData.characters.insert("P", at: sceneData.index(before: playerPosition))
                    return true
                }
            case .right:
                if sceneData[sceneData.characters.index(after: playerPosition)] == " " {
                    sceneData.characters.remove(at: playerPosition)
                    sceneData.characters.insert(" ", at: playerPosition)
                    sceneData.characters.remove(at: sceneData.index(after: playerPosition))
                    sceneData.characters.insert("P", at: sceneData.index(after: playerPosition))
                    return true
                }
            case .top:
                if sceneData[sceneData.characters.index(playerPosition, offsetBy: -sceneWidth)] == " " {
                    sceneData.characters.remove(at: playerPosition)
                    sceneData.characters.insert(" ", at: playerPosition)
                    sceneData.characters.remove(at: sceneData.index(playerPosition, offsetBy: -sceneWidth))
                    sceneData.characters.insert("P", at: sceneData.index(playerPosition, offsetBy: -sceneWidth))
                    return true
                }
            }
        }
        return false
    }
    
//    func plantBomb() {
//        
//    }
}
