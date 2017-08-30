//
//  GameLayoutController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class GameLayoutController: UIViewController {
    
    @IBOutlet weak var gameContainer: UIView!
    
    var detailsController: DetailsController!
    var gameMapController: GameMapController!
    var controlPanelController: ControlPanelController!
    
    var pause = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pause = UIButton()
        pause.pauseStyle()
        pause.addTarget(self, action: #selector(turnOffpause), for: .touchUpInside)
    }
    
    func turnOffpause() {
        detailsController.isPause = false
        pause.removeFromSuperview()
    }
    
    func turnOnPause(state: Bool) {
        if state {
            pause.frame = gameMapController.mapScroll.frame
            gameContainer.addSubview(pause)
            
        } else {
            pause.removeFromSuperview()
        }
    }
    
    // Returns to menu page
    func turnToHome() {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsControllerSegue",
            let controller = segue.destination as? DetailsController {
            
            detailsController = controller
            
            detailsController.onPauseTap = { [weak self] state in
                self?.turnOnPause(state: state)
            }
            
            detailsController.onHomeTap = { [weak self] in
                self?.turnToHome()
            }
            
        } else if segue.identifier == "GameMapControllerSegue",
            let controller = segue.destination as? GameMapController {
            
            gameMapController = controller
            
        } else if segue.identifier == "ControlPanelController",
            let controller = segue.destination as? ControlPanelController {
            
            controlPanelController = controller
        }
    }
}

extension UIButton {
    
    func pauseStyle() {
        backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.9)
        
        imageView?.contentMode = .scaleAspectFit
        tintColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5)
        setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysTemplate), for: .normal)
    }
}
