//
//  MultiPlayerGame.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/30/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPlayerGame: UIViewController, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate {
    
    private let manager = ConnectionServiceManager()
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createNewGame(_ sender: UIButton) {
        manager.setBrowser()
        manager.serviceBrowser.delegate = self
        self.present(manager.serviceBrowser, animated: true, completion: nil)
    }
    
    @IBAction func joinToNewGame(_ sender: UIButton) {
        manager.advertiseSelf(true)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        manager.serviceBrowser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        manager.serviceBrowser.dismiss(animated: true, completion: nil)
    }
    //Check how this method exactly working
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        print("Hello")
        advertiserAssistant.stop()
    }
}
