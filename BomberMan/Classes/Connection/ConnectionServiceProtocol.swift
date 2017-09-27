//
//  ConnectionServiceProtocol.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

protocol ConnectionServiceManagerDelegate {
    func connectedDevicesChanged(manager: ConnectionServiceManager, connectedDevices: [String])
    func dataReceived(manager: ConnectionServiceManager, playerData: String)
    func connectionLost()
}
