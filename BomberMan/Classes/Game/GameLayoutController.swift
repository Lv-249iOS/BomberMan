//
//  GameLayoutController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class GameLayoutController: UIViewController {
    
    @IBOutlet weak var multiplayerContainerView: UIView!
    @IBOutlet weak var gameContainer: UIView!
    
    enum AdditionView: Int {
        case pause = 0
        case nextLevel = 1
        case gameOver = 2
        case gameWin = 3
    }
    
    var isSingleGame = true
    let brain = Brain.shared
    
    /// Controllers that are on the game layout
    var singleplayerDetailsController: SingleplayerDetailsController?
    var multiplayerDetailsController: MultiplayerDetailsController?
    var gameMapController: GameMapController!
    var controlPanelController: ControlPanelController!
    
    /// Addition view that will be shown in runtime
    var pause: PauseView?
    var gameOver: GameOverView?
    var gameWin: WinView?
    var moveToNextLevel: MoveToNextLevelView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        singleplayerDetailsController?.resetTimer()
        brain.invalidateTimers()
        removeAdditionView(additionView: AdditionView.nextLevel)
        brain.initializeGame(with: brain.currentLvl + 1, completelyNew: false)
        gameMapController.updateContentSize()
        singleplayerDetailsController?.runTimer()
        presentScore(score: brain.score)
    }
    
    func gameEnd(didWin: Bool) {
        singleplayerDetailsController?.resetTimer()
        brain.invalidateTimers()
        if didWin && brain.currentLvl < 8 {
            createMoveToNextLevelView()
            gameContainer.addSubview(moveToNextLevel!)
            
        } else if !didWin && brain.currentLvl == 8 {
            createGameWinView()
            gameContainer.addSubview(gameWin!)
            askUserAboutName()
            // MARK: You must remove game win view if clicked on but
            
        } else {
            createGameOverView()
            gameContainer.addSubview(gameOver!)
            
            if brain.score > 0 {
                askUserAboutName()
            }
        }
        presentScore(score: brain.score)
    }
    
    func replayGame(isGameOver: Bool) {
        singleplayerDetailsController?.resetTimer()
        brain.invalidateTimers()
        singleplayerDetailsController?.runTimer()
        let additionViewName = isGameOver ? AdditionView.gameOver : AdditionView.nextLevel
        removeAdditionView(additionView: additionViewName)
        brain.initializeGame(with: brain.currentLvl, completelyNew: false)
        gameMapController.updateContentSize()
        presentScore(score: brain.score)
    }
    
    // Catchs pause state from details
    func changePause(state: Bool) {
        if state {
            createPauseView()
            controlPanelController.setButtonState(isEnabled: false)
            gameContainer.addSubview(pause!)
            brain.stopMobsMovement()
            singleplayerDetailsController?.stopTimer()
            
        } else {
            singleplayerDetailsController?.isPause = false
            controlPanelController.setButtonState(isEnabled: true)
            brain.startMobsMovement()
            singleplayerDetailsController?.runTimer()
            removeAdditionView(additionView: AdditionView.pause)
        }
    }
    
    // Returns to menu page
    func turnToHome() {
        brain.invalidateTimers()
        dismiss(animated: true, completion: nil)
    }
    
    func presentScore(score:Int){
        singleplayerDetailsController?.present(score: Double(score))
    }
    
    func presentTimer(time: TimeInterval) {
        singleplayerDetailsController?.present(time: "\(time)")
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
        if segue.identifier == "SingleplayerDetailsSegue",
            let controller = segue.destination as? SingleplayerDetailsController {
            prepareDetailsController(controller)
            multiplayerContainerView.removeFromSuperview()
            
        } else if segue.identifier == "MultiplayerDetailsSegue",
            let controller = segue.destination as? MultiplayerDetailsController {
            prepareMultiplayerDetailsController(controller)
            
        } else if segue.identifier == "GameMapControllerSegue",
            let controller = segue.destination as? GameMapController {
            prepareGameMapController(controller: controller)
            
        } else if segue.identifier == "ControlPanelControllerSegue",
            let controller = segue.destination as? ControlPanelController {
            prepareControlPanelController(controller: controller)
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "MultiplayerDetailsSegue" && isSingleGame == true) ||
            (identifier == "SingleplayerDetailsSegue" && isSingleGame == false) {
            return false
        }
        
        return true
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
    func prepareDetailsController(_ controller: SingleplayerDetailsController) {
        singleplayerDetailsController = controller
        
        singleplayerDetailsController?.onPauseTap = { [weak self] state in
            self?.changePause(state: state)
        }
        
        singleplayerDetailsController?.onHomeTap = { [weak self] in
            self?.turnToHome()
        }
    }
    
    // binds methods between details and game scene
    func prepareMultiplayerDetailsController(_ controller: MultiplayerDetailsController) {
        multiplayerDetailsController = controller
        
        multiplayerDetailsController?.onHomeTap = { [weak self] in
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

