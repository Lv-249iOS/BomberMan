//
//  TransitionData.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class TransitionData: UIViewController {

    @IBOutlet weak var connectionsLabel: UILabel!
    
    let manager = ConnectionServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
    }
    
    ///In this function you should write the processing of data received from another player
    func change(playerData : String) {
        /*
         Processing of player data received from another player
         */
    }
    
    /*
        For sending data you should write in IBAction next lines:
        manager.sendData(playerData: "There must be string with playerData")
     */
    
}

extension TransitionData : ConnectionServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ConnectionServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func dataChanged(manager: ConnectionServiceManager, playerData: String) {
        OperationQueue.main.addOperation {
            print(playerData) //print
            self.change(playerData: playerData)
            NSLog("%@", "Unknown player data value received: \(playerData)")
        }
    }
}

