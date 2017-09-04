//
//  DataServiceManager.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ConnectionServiceManagerDelegate {
    func connectedDevicesChanged(manager: ConnectionServiceManager, connectedDevices: [String])
    func dataReceived(manager: ConnectionServiceManager, playerData: String)
    func connectionLost()
}

protocol InvitationDelegate {
    func invitationWasReceived(fromPeer: String)
}

class ConnectionServiceManager: NSObject {
    
    static let shared = ConnectionServiceManager()
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let playerServiceType = "multi-player"
    
    //This peerID's name can be changed to username
    private var myPeerId : MCPeerID!
    
    //maxCountOfPlayers can't be more than 7
    private var maxCountOfPlayers = 4
    
    var invitationHandler: ((Bool, MCSession?) -> Swift.Void)!
    var session: MCSession!
    var serviceAdvertiser : MCNearbyServiceAdvertiser? = nil
    var serviceBrowser : MCBrowserViewController? = nil
    
    var delegate: ConnectionServiceManagerDelegate?
    var browserDelegate : MCBrowserViewControllerDelegate?
    var invitationDelegate: InvitationDelegate?
    
    private override init() {
        super.init()
        myPeerId = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession (peer: self.myPeerId,securityIdentity: nil,encryptionPreference: .required)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: playerServiceType)
        serviceBrowser = MCBrowserViewController(serviceType: playerServiceType, session: session)
        session.delegate = self
        serviceAdvertiser?.delegate = self
    }
    
    func startBrowser() {
        browserDelegate = serviceBrowser?.delegate
        serviceBrowser?.browser?.startBrowsingForPeers()
        serviceBrowser?.maximumNumberOfPeers = maxCountOfPlayers
    }
    
    func stopBrowser() {
        serviceBrowser?.browser?.stopBrowsingForPeers()
        serviceBrowser?.dismiss(animated: true, completion: nil)
    }
    
    func disconnect() {
        session.disconnect()
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

extension ConnectionServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Swift.Void) {
        NSLog("%@", "didReceiveInvitationFromPeer: \(peerID)")
        self.invitationHandler = invitationHandler
        invitationDelegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
}

extension ConnectionServiceManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        self.delegate?.dataReceived(manager: self, playerData: str)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}
