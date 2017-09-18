//
//  Brain+Multiplayer.swift
//  BomberMan
//
//  Created by Andriy_Moravskyi on 9/18/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

extension Brain {
    
    func initializeMultiplayerGame() {
        for name in devices {
            addPlayer(name: name)
        }
        setmultiplayerlevel(playersCount: players.count)
        addMobsAndUpgrates()
        redrawScene?()
   
    }

    func setmultiplayerlevel(playersCount: Int) {
        var battlelevel = ""
        if playersCount == 2 {
            width = 11
            battlelevel = MultiplayerLevels().getlevel(name: "duel")
        } else if playersCount <= 4 {
            width = 15
            battlelevel = MultiplayerLevels().getlevel(name: "battle")
        } else {
            width = 21
            battlelevel = MultiplayerLevels().getlevel(name: "mincingmachine")
        }
        getPlayers(for: &battlelevel)
        toTiles(scene: battlelevel)
    }
}
