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
        players.removeAll()
        for name in devices {
            addPlayer(name: name)
        }
        setmultiplayerlevel(playersCount: players.count)
        DispatchQueue.main.async { [weak self] in
            self?.setUpgradesIfNeeded?()
        }
        redrawScene?()
   
    }

    func setmultiplayerlevel(playersCount: Int) {
        var battlelevel = ""
        if playersCount == 2 {
            width = 11
            battlelevel = MultiplayerLevels().getlevel(level: .duel)
        } else if playersCount <= 4 {
            width = 15
            battlelevel = MultiplayerLevels().getlevel(level: .battle)
        } else {
            width = 21
            battlelevel = MultiplayerLevels().getlevel(level: .mincingmachine)
        }
        getPlayers(for: &battlelevel)
        toTiles(scene: battlelevel)
    }
}
