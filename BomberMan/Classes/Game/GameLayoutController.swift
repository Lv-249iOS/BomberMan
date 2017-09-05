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
    
    var topTenController: TopTenController?
    var detailsController: DetailsController!
    var gameMapController: GameMapController!
    var controlPanelController: ControlPanelController!
    let brain = Brain.shared
    //var game = Game()
    var pause = PauseView()
    var gameOver = GameOverView()
    var moveToNextLevel = MoveToNextLevelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pause.onPauseButtTap = { [weak self] in
            self?.changePause(state: false)
        }
        
        gameOver.onRepeatButtTap = { [weak self] in
            self?.replayGame(isGameOver: true)
        }
        
        moveToNextLevel.onMoveOnButtTap = { [weak self] in
            self?.moveToNextLvl()
        }
        
        moveToNextLevel.onRepeatButtTap = { [weak self] in
            self?.replayGame(isGameOver: false)
        }
        
        brain.gameEnd = { [weak self] isHeroDead in
            self?.gameEnd(didWin: isHeroDead)
        }
    }
    
    func moveToNextLvl() {
        moveToNextLevel.removeFromSuperview()
        brain.initializeGame(with: brain.currentLvl + 1)
        gameMapController.updateContentSize()
        
    }
    
    func gameEnd(didWin: Bool) {
        if didWin {
            moveToNextLevel.frame = gameMapController.mapScroll.frame
            gameContainer.addSubview(moveToNextLevel)
        } else {
            askUserAboutName()
            gameOver.frame = gameMapController.mapScroll.frame
            gameContainer.addSubview(gameOver)
        }
        
    }
    
    func replayGame(isGameOver: Bool) {
        isGameOver ? gameOver.removeFromSuperview() : moveToNextLevel.removeFromSuperview()
    }
    
    // Catchs pause state from details
    func changePause(state: Bool) {
        if state {
            pause.frame = gameMapController.mapScroll.frame
            controlPanelController.setButtonState(isEnabled: false)
            gameContainer.addSubview(pause)
            
        } else {
            detailsController.isPause = false
            controlPanelController.setButtonState(isEnabled: true)
            pause.removeFromSuperview()
        }
    }
    
    // Returns to menu page
    func turnToHome() {
        brain.invalidateTimers()
        dismiss(animated: true, completion: nil)
    }
    
    // Controls arrow's events
    func move(direction: Direction) {
        brain.move(to: direction, player: &brain.player)
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
        
        controlPanelController.moveTo = { [weak self]  path in
            self?.move(direction: path)
        }
        
        controlPanelController.setBomb = { [weak self] in
            self?.setBomb()
        }
    }
    
    // binds methods between details and game scene
    func prepareDetailsController(controller: DetailsController) {
        detailsController = controller
        
        detailsController.onPauseTap = { [weak self] state in
            self?.changePause(state: state)
        }
        
        detailsController.onHomeTap = { [weak self] in
            self?.turnToHome()
        }
    }
    
    // Alert to save yser's nickname to record score
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
            
            alert.view.tintColor = UIColor.black
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion:  nil)
        }
    }
}
