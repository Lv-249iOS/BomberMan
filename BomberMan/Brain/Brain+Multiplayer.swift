//
//  Brain+Multiplayer.swift
//  BomberMan
//
//  Created by Andriy_Moravskyi on 9/18/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    
    func initializeMultiplayerGame(with lvlNumber: String,playerscount: Int, completelyNew: Bool) {
        resetScore(ifNeeded: completelyNew)
        setmultiplayerlevel(nameoflevel: lvlNumber, playersCount: playerscount)
        addMobsAndUpgrates()
        redrawScene?()
   
    }

   

    func setmultiplayerlevel(nameoflevel: String,playersCount: Int) {
        if nameoflevel == "duel" { width = 11 }
        else if nameoflevel == "battle" { width = 15 }
        else { width = 21 }
        var battlelevel = MultiplayerLevels().getlevel(name: nameoflevel)
        getPlayers(for: &battlelevel)
        toTiles(scene: battlelevel)
    }

    
}
