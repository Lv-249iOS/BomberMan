//
//  RatingController.swift
//  BomberMan
//
//  Created by Alejandro Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class RatingController: UIViewController {
    
    static let shared = RatingController()
    
    var topTenController: TopTenController?
    var scoresManager = ScoresManager.shared
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cleanScores(_ sender: Any) {
        createScoreAlert(title: "Do you really want clean scores?", messege: "Your records will be empty")
    }
   
    override func viewDidAppear(_ animated: Bool) {
        askUserAboutName()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Asks user to confirm cleaning of records
    func createScoreAlert(title: String, messege: String) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
            self?.topTenController?.clearScores()
            self?.scoresManager.removeFromArchive()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion:  nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TopTenSegue",
            let controller = segue.destination as? TopTenController {
            topTenController = controller
            
        }
    }
    
    // Alert to save yser's nickname
    func askUserAboutName() {
        let alert = UIAlertController(title: "Save your score", message: "Input your name here", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            let nicknameField = alert.textFields![0]
            let score = UserScore(username: nicknameField.text ?? "User", score: 45600)
            ScoresManager.shared.saveData(score: score)
            self.topTenController?.scores.append(score)
            self.topTenController?.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) -> Void in })
        
        alert.addTextField { (nicknameField: UITextField) in
            nicknameField.placeholder = "your name is..."
            nicknameField.clearButtonMode = .whileEditing
            nicknameField.keyboardType = .default
            nicknameField.keyboardAppearance = .dark
            
            alert.view.tintColor = UIColor.purple
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion:  nil)
        }
    }
}

