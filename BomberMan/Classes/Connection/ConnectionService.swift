//
//  DataServiceManager.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol InvitationDelegate {
    func invitationWasReceived(fromPeer: String)
}

class ConnectionServiceManager: NSObject {
   
    private override init() {
        super.init()
        myPeerId = MCPeerID(displayName: UIDevice.current.name)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: playerServiceType)
        serviceBrowser = MCBrowserViewController(serviceType: playerServiceType, session: session)
        session.delegate = self as MCSessionDelegate
        serviceAdvertiser?.delegate = self
        delegate = self as? ConnectionServiceManagerDelegate
    }
    
    static let shared = ConnectionServiceManager()
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let playerServiceType = "multi-player"
    
    //This peerID's name can be changed to username
    private var myPeerId : MCPeerID!
    
    //maxCountOfPlayers can't be more than 8
    private var maxCountOfPlayers = 8
    
    //Needed for accepting or declining invitation in Alert
    var invitationHandler: ((Bool, MCSession?) -> Swift.Void)!
    
    var serviceAdvertiser : MCNearbyServiceAdvertiser? = nil
    var serviceBrowser : MCBrowserViewController? = nil
    
    var delegate: ConnectionServiceManagerDelegate?
    var browserDelegate : MCBrowserViewControllerDelegate?
    var invitationDelegate: InvitationDelegate?
    
    lazy var session: MCSession = {
        let session = MCSession (peer: self.myPeerId,securityIdentity: nil,encryptionPreference: .required)
        return session
    } ()
    
    
    
    func startBrowser() {
        browserDelegate = serviceBrowser?.delegate
        serviceBrowser?.browser?.startBrowsingForPeers()
        serviceBrowser?.maximumNumberOfPeers = maxCountOfPlayers
    }
    
    func stopBrowser() {
        serviceBrowser?.browser?.stopBrowsingForPeers()
        serviceBrowser?.dismiss(animated: true, completion: nil)
    }
    
    func killConnection() {
        session.disconnect()
        stopBrowser()
        advertiseSelf(false)
    }
    
    func advertiseSelf(_ advertise: Bool) {
        if advertise {
            serviceAdvertiser?.startAdvertisingPeer()
        } else {
            serviceAdvertiser?.stopAdvertisingPeer()
        }
    }
    
    func connectionActive() -> Bool {
        if session.connectedPeers.count > 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func sendData(playerData: String) {
        NSLog("%@", "sendPlayer: \(playerData) to \(session.connectedPeers.count) peers")
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(playerData.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
}
