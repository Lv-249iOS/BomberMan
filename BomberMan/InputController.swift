//
//  InputController.swift
//  BomberMan
//
//  Created by Zhanna Moskaliuk on 8/29/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class InputController: UIViewController {
    
    @IBOutlet weak var input: UITextField!
    
    @IBAction func Ok(_ sender: Any) {
        let score = UserScore(username: input.text ?? "User", score: 456)
        ScoresManager.shared.saveData(score: score)
    }
}
