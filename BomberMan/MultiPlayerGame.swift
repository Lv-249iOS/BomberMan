//
//  MultiPlayerGame.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/30/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPlayerGame: UIViewController, MCBrowserViewControllerDelegate, InvitationFromUserDelegate {
    
    private let manager = ConnectionServiceManager()
    
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createNewGame(_ sender: UIButton) {
        manager.startBrowser()
        manager.serviceBrowser.delegate = self
        self.present(manager.serviceBrowser, animated: true, completion: nil)
    }
    
    @IBAction func joinToNewGame(_ sender: UIButton) {
        manager.advertiseSelf(true)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        manager.stopBrowser()
        //Check if someone connected and if it true create game
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        manager.stopBrowser()
    }
    
    func invitationWasReceived(fromPeer: MCPeerID) {
        //Show alert with offer accept or decline invitation
        //manager.invitation(accept: Bool)
    }
}
