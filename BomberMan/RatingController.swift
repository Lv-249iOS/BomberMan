//
//  RatingController.swift
//  BomberMan
//
//  Created by Alejandro Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class RatingController: UIViewController {
    
    var topTenController: TopTenController!
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cleanScores(_ sender: Any) {
        createScoreAlert(title: "Do you really want clean scores?" , messege: "Your records will be empty")
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func createScoreAlert(title: String, messege: String) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
        self?.topTenController.clearScores()
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
}
