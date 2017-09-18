//
//  MultiplayerDetailsController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/15/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class MultiplayerDetailsController: UIViewController {
    
    /// Closure for proccessing on home button taped event
    var onHomeTap: (()->())?
    
    /// This field is used for filling details panel with players names
    /// if it's nil on UI will be presented names "None"
    var playersNames: [String]?
    
    @IBOutlet var detailsView: MultiDetailsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayersName()
        setPlayersNames()
        detailsView.onHomeButtTap = { [weak self] in
            self?.homeTap()
        }
    }
    
    private func homeTap() {
        onHomeTap?()
    }
    
    private func setPlayersNames() {
        detailsView.setNames(names: playersNames ?? [])
    }
    
    private func initPlayersName() {
        playersNames = [UIDevice.current.name]
        let peers = ConnectionServiceManager.shared.session.connectedPeers
        if peers.count > 0 {
            for peer in peers {
                playersNames?.append(peer.displayName)
            }
        }
    }
}
