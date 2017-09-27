//
//  ConnectionServiceManager+MCNearbyServiceAdvertiserDelegate.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
import MultipeerConnectivity

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
