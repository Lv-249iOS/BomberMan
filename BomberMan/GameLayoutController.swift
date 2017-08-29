//
//  GameLayoutController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class GameLayoutController: UIViewController {
    var detailsController: DetailsController!
    var gameMapController: GameMapController!
    var controlPanelController: ControlPanelController!
    
    var pause: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pause = UIButton(frame: view.frame)
        pause.imageView?.contentMode = .scaleAspectFit
        pause.tintColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5)
        

        let tintedImage = #imageLiteral(resourceName: "pause").withRenderingMode(.alwaysTemplate)

        pause.setImage(tintedImage, for: .normal)
        pause.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.9)
        pause.addTarget(self, action: #selector(pauseOff), for: .touchUpInside)
    }
    
    func pauseOff() {
        pause.removeFromSuperview()
    }
    
    func turnOnPause() {
        view.addSubview(pause)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsControllerSegue", let controller = segue.destination as? DetailsController {
            detailsController = controller
            
            detailsController.onPauseTap = turnOnPause
            
        } else if segue.identifier == "GameMapControllerSegue", let controller = segue.destination as? GameMapController {
            gameMapController = controller
            
        } else if segue.identifier == "ControlPanelController", let controller = segue.destination as? ControlPanelController {
            controlPanelController = controller
        }
        
    }
}
