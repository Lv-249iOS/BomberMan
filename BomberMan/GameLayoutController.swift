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
    let brain = Brain.shared
    
    var pause = PauseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pause.onPauseButtTap = { [weak self] in
            self?.turnOffpause()
        }
    }
    
    // Turns off pause from game scene
    func turnOffpause() {
        detailsController.isPause = false
        pause.removeFromSuperview()
    }
    
    // Catchs pause state from details
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
    
    // Controls arrow's events
    func move(direction: Direction) {
        brain.move(to: direction, player: brain.player)
        
       
    }

    // Controls bomb setting
    func setBomb() {
        brain.plantBomb(player: brain.player)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsControllerSegue",
            let controller = segue.destination as? DetailsController {
            prepareDetailsController(controller: controller)
            
        } else if segue.identifier == "GameMapControllerSegue",
            let controller = segue.destination as? GameMapController {
            prepareGameMapController(controller: controller)
            
            
        } else if segue.identifier == "ControlPanelControllerSegue",
            let controller = segue.destination as? ControlPanelController {
            prepareControlPanelController(controller: controller)
            
        }
    }
    
    // Binds methods between game map controller and  main game scene
    func prepareGameMapController(controller: GameMapController) {
        gameMapController = controller
    }
    
    // Binds methods between control panel and game scene
    func prepareControlPanelController(controller: ControlPanelController) {
        controlPanelController = controller
        
        controlPanelController.onArrowTap = { [weak self]  path in
            self?.move(direction: path)
        }
        
        controlPanelController.onBombTap = { [weak self] in
            self?.setBomb()
        }
    }
    
    // binds methods between details and game scene
    func prepareDetailsController(controller: DetailsController) {
        detailsController = controller
        
        detailsController.onPauseTap = { [weak self] state in
            self?.turnOnPause(state: state)
        }
        
        detailsController.onHomeTap = { [weak self] in
            self?.turnToHome()
        }
    }
}
