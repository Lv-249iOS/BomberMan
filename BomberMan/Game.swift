//
//  Game.swift
//  BomberMan
//
//  Created by Andriy_Moravskyi on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
class Game {
    let score = 0
    let brain = Brain.shared
    let levels = Levels.init()
    
    func gameStart(){
        guard let data = levels.level(with: 1) else { return }
        let scene = Scene.init(data: data, width: 10)
        brain.appendScene(with: scene.width, data: scene.data)
        
        //brain.setmobdirection()
        //brain.startmobmovement()
        
    }
    func gameEnd(){}
    let players = [Int]()
    
}
