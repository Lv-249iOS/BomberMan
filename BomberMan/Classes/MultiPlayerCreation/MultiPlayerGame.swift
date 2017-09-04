//
//  MultiPlayerGame.swift
//  BomberMan
//
//  Created by Yevhen Roman on 8/30/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPlayerGame: UIViewController, MCBrowserViewControllerDelegate, InvitationDelegate {
    
    private let manager = ConnectionServiceManager.shared
    
    @IBOutlet weak var phoneView: PhoneView?
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.invitationDelegate = self
        
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewGame(_ sender: UIButton) {
        manager.startBrowser()
        guard let browser = manager.serviceBrowser else { return }
        browser.delegate = self
        self.present(browser, animated: true, completion: nil)
    }
    
    
    var isWaiting = true
    @IBAction func joinToNewGame(_ sender: UIButton) {
        if isWaiting == false {
            isWaiting = true
            changeSceneView()
        } else {
            isWaiting = false
            changeSceneView()
        }
    }
    
    func changeSceneView() {
        if !isWaiting {
            manager.advertiseSelf(true)
            phoneView?.runSpinAnimationOn()
            joinButton.setTitle("Waiting...", for: .normal)
        } else {
            manager.advertiseSelf(false)
            phoneView?.stopSpinAnimation()
            joinButton.setTitle("Join", for: .normal)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        manager.stopBrowser()
        //Check if someone connected and if it true create game, use manager.connectionActive()
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        manager.stopBrowser()

        manager.disconnect()
    }
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "I heard you play cool!", message: "\(fromPeer) wants to play with you...", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "To battle!", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.manager.invitationHandler(true, self.manager.session)
            //Invitation was accepted you need to prepare user to game there ↓
        }
        
        let declineAction = UIAlertAction(title: "No, I'm afraid", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.manager.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
