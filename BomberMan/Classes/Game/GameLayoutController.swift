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
    var pause = PauseView()
    var gameOver = GameOverView()
    var gameWin = WinView()
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
        
        brain.gameEnd = { [weak self] didWin in
            if !didWin {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self?.gameEnd(didWin: didWin)
                }
            } else {
                self?.gameEnd(didWin: didWin)
            }
        }
        
        brain.presentTime = { [weak self] time in
            self?.presentTimer(time: time)
        }
        
        brain.refreshScore = { [weak self] score in
            self?.presentScore(score: score)
        
        }
    }
    
    
    
    func moveToNextLvl() {
        detailsController.resetTimer()
        brain.invalidateTimers()
        moveToNextLevel.removeFromSuperview()
        brain.initializeGame(with: brain.currentLvl + 1, completelyNew: false)
        gameMapController.updateContentSize()
        detailsController.runTimer()
        presentScore(score: brain.score)
    }
    
    func gameEnd(didWin: Bool) {
        detailsController.resetTimer()
        brain.invalidateTimers()
        if didWin && brain.currentLvl < 8 {
            moveToNextLevel.frame = gameMapController.mapScroll.frame
            gameContainer.addSubview(moveToNextLevel)
            
        } else if !didWin && brain.currentLvl == 8 {
            gameWin.frame = gameMapController.mapScroll.frame
            gameContainer.addSubview(gameWin)
            askUserAboutName()
            // MARK: You must remove game win view if clicked on but
            
        } else {
            gameOver.frame = gameMapController.mapScroll.frame
            gameContainer.addSubview(gameOver)
            if brain.score > 0 {
                askUserAboutName()
            }
        }
        presentScore(score: brain.score)
    }
    
    func replayGame(isGameOver: Bool) {
        detailsController.resetTimer()
        brain.invalidateTimers()
        detailsController.runTimer()
        isGameOver ? gameOver.removeFromSuperview() : moveToNextLevel.removeFromSuperview()
        brain.initializeGame(with: brain.currentLvl, completelyNew: false)
        gameMapController.updateContentSize()
        presentScore(score: brain.score)
    }
    
    // Catchs pause state from details
    func changePause(state: Bool) {
        if state {
            pause.frame = gameMapController.mapScroll.frame
            controlPanelController.setButtonState(isEnabled: false)
            gameContainer.addSubview(pause)
            brain.stopMobsMovement()
            detailsController.stopTimer()
            
        } else {
            detailsController.isPause = false
            controlPanelController.setButtonState(isEnabled: true)
            brain.startMobsMovement()
            detailsController.runTimer()
            pause.removeFromSuperview()
        }
    }
    
    // Returns to menu page
    func turnToHome() {
        brain.invalidateTimers()
        dismiss(animated: true, completion: nil)
    }
    
    func presentScore(score:Int){
        detailsController.present(score: Double(score))
    }
    
    
    func presentTimer(time: TimeInterval) {
        detailsController.present(time: "\(time)")
    }
    
    // Controls arrow's events
    func move(direction: Direction) {
        brain.move(to: direction, playerName: UIDevice.current.name)
    }
    
    // Controls bomb setting
    func setBomb() {
        brain.plantBomb(playerName: UIDevice.current.name)
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
