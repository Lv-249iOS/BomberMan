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
    private var sceneData: String = ""
    private var sceneWidth = 0
    
    func appendScene(with width: Int, scene: String) {
        sceneData = scene
        sceneWidth = width
    }

    func move(to direction: Direction, player: Player) {
        if let playerPosition = sceneData.characters.index(of: "0") {
            switch direction {
            case .bottom:
                if sceneData[sceneData.characters.index(playerPosition, offsetBy: sceneWidth)] == " " {
                    GameMapController.shared.moveDown()
                }
            case .left:
                if sceneData[sceneData.characters.index(before: playerPosition)] == " " {
                    GameMapController.shared.moveLeft()
                }
            case .right:
                if sceneData[sceneData.characters.index(after: playerPosition)] == " " {
                    GameMapController.shared.moveRight()
                }
            case .top:
                if sceneData[sceneData.characters.index(playerPosition, offsetBy: -sceneWidth)] == " " {
                    GameMapController.shared.moveUp()
                }
            }
        }
    }
    
//    func plantBomb() {
//        
//    }
}
