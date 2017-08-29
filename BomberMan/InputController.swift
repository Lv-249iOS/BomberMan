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
    @IBOutlet weak var output: UILabel!
    
    // Here I set current input to label
    @IBAction func ok(_ sender: Any) {
        output.text = input.text
         UserDefaults.standard.set(input.text, forKey: "UserName")
        input.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "UserName") as? String {
            return output.text = x
        }
    }
}
