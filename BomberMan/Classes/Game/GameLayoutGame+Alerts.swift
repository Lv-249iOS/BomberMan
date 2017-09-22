//
//  GameLayoutGame+Alerts.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/22/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

extension GameLayoutController {

    // Creates alert for approving home button event
    // Precondition: Calls if on home button taped
    // Postcondition: if ok: invalidates timers in single game/ kills connection in multiplayer game
    func backToHomeCheckingAlert() {
        let alert = UIAlertController(title: "Back to home",
                                      message: "Do you want to leave game?",
                                      preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.backToHomeAction()
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            if self?.isSingleGame ?? true {
                self?.changePause(state: false)
            }
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        self.present(alert, animated: true, completion:  nil)
    }
    
    // Alert to save yser's nickname to record score
    func askUserAboutName() {
        let alert = UIAlertController(title: "Save your score", message: "Input your name here", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            let nicknameField = alert.textFields![0]
            let score = UserScore(username: nicknameField.text ?? "User", score: self.brain.score)
            ScoresManager.shared.saveData(score: score)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) -> Void in })
        alert.addTextField { (nicknameField: UITextField) in
            nicknameField.placeholder = "your name is..."
            nicknameField.clearButtonMode = .whileEditing
            nicknameField.keyboardType = .default
            nicknameField.keyboardAppearance = .dark
            
            alert.view.tintColor = UIColor.black
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion:  nil)
        }
    }
}
