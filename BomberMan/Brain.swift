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
    var sceneData: String = ""
    var sceneWidth = 0

    func move(to direction: Direction, player: Player) {
        switch direction {
        case .bottom: break
        case .left: break
        case .right: break
        case .top: break
        }
    }
    
    func plantBomb() {
        
    }
}
