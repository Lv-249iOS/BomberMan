//
//  Game.swift
//  BomberMan
//
//  Created by Andriy_Moravskyi on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
class Game {
    let brain = Brain.shared
    let score = Int()
    init(){
        brain.gameEnd = { [weak self] didWin in
            self?.gameEnd(didWin: didWin)
        }
    }
    
    func gamestart(){}
    
    func gameEnd(didWin: Bool){
        
    }
    let players = [Int]()

}
