//
//  Game.swift
//  BomberMan
//
//  Created by Andriy_Moravskyi on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
var level = 1

extension Brain {
    
    func startGamelevel()  {
        if level == 1 {
            let levelscene = Levels().level(with: 1)
            let scene  = Scene.init(data: levelscene ?? "", width: 10)
            initializeGame(withScene: scene)
            
        }
        let levelscene = Levels().level(with: level)
        let scene  = Scene.init(data: levelscene ?? "", width: 15)
        initializeGame(withScene: scene)
        
    }
    func endOfGame() {
        
    }
    
}
