//
//  FoundPlayers.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/30/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class FoundPlayers: UITableViewController {

    let manager = ConnectionServiceManager()
    
    func connectionPeeers() {
        
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.serviceBrowser.startBrowsingForPeers()
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 0
    }

 

}
