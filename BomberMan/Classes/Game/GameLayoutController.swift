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
    var eventParser: EventParser?
    var gameMapController: GameMapController!
    var controlPanelController: ControlPanelController!
    
    /// Addition view that will be shown in runtime
    var pause: PauseView?
    var gameOver: GameOverView?
    var gameWin: WinView?
    var moveToNextLevel: MoveToNextLevelView?
    
    // Precondition: calls if you successfully done previous level
    // Postcondition: resets timer, presents score, shows addition view,
    // init next level and updates content size of map
    func moveToNextLvl() {
        singleplayerDetailsController?.resetTimer()
        brain.invalidateTimers()
        removeAdditionView(additionView: AdditionView.nextLevel)
        brain.initializeGame(with: brain.currentLvl + 1, completelyNew: false)
        gameMapController.updateContentSize()
        singleplayerDetailsController?.runTimer()
        presentScore(score: brain.score)
    }
    
    // Precondition: calls when game over. It's possible in three cases:
    // and due to it program present three diffenet runtime view:
    // 1. game over view with opportunity to try again
    // 2. move to next with opportunity try again this level or move to next
    // 3. win view with opportunity to replay game, seek to rating and back to home
    func gameEnd(didWin: Bool) {
        singleplayerDetailsController?.resetTimer()
        brain.invalidateTimers()
        
        if didWin && brain.currentLvl < 8 {
            createMoveToNextLevelView()
            gameContainer.addSubview(moveToNextLevel!)
            
        } else if didWin && brain.currentLvl == 8 {
            createGameWinView()
            gameContainer.addSubview(gameWin!)
            askUserAboutName()
            
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
                self?.createGameOverView()
                self?.gameContainer.addSubview((self?.gameOver)!)
                if (self?.brain.score)! > 0 { self?.askUserAboutName() }
            }
        }
        
        presentScore(score: brain.score)
    }
    
    // Precondition: Calls if you want to play level again
    // gets isGameOver value that determines what addition view needs to be removed
    // Postcondition: reset timers, score and redraw map
    func replayLevel(isGameOver: Bool) {
        singleplayerDetailsController?.resetTimer()
        brain.invalidateTimers()
        singleplayerDetailsController?.runTimer()
        let additionViewName = isGameOver ? AdditionView.gameOver : AdditionView.nextLevel
        removeAdditionView(additionView: additionViewName)
        brain.initializeGame(with: brain.currentLvl, completelyNew: false)
        gameMapController.updateContentSize()
        presentScore(score: brain.score)
    }
    
    // Precondition: Calls if you won game and want to play again
    // Postcondition: reset timers, score and redraw map and set 0 level
    func replayGame() {
        singleplayerDetailsController?.resetTimer()
        brain.invalidateTimers()
        singleplayerDetailsController?.runTimer()
        removeAdditionView(additionView: AdditionView.gameWin)
        brain.currentLvl = 0
        brain.initializeGame(with: brain.currentLvl, completelyNew: false)
        gameMapController.updateContentSize()
        brain.score = 0
        presentScore(score: brain.score)
    }
    
    // Precondition: Calls if you won game and want to see rating table
    // Postcondition: Raises Rating scene
    // if clicks to close button you unwind to current position
    func moveToRating() {
        // MARK: go to rating scene
        let ratingController: UIStoryboard = UIStoryboard(name: "Rating", bundle: nil)
        let nextViewController = ratingController.instantiateViewController(withIdentifier: "ratingIdentifier") as! RatingController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // Catchs pause state from details
    // Precondition: Calls if pause state was changed
    // Postcondition: controls pause states and stops/runs timers,
    // mobs, blocks control panel
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
    
    func multilayerEnd(player: String) {
        if UIDevice.current.name == player {
            createGameWinView()
            gameContainer.addSubview(gameWin!)
        } else {
            createGameOverView()
            gameContainer.addSubview(gameOver!)
        }
    }
    
    // Precondition: calls when multilayer game
    // Postcondition: init event paeser and connection manager delegate for sharing data
    func prepareMultiplayergameIfNeeded() {
        if !isSingleGame {
            eventParser = EventParser()
            ConnectionServiceManager.shared.delegate = self
            
            brain.setUpgradesIfNeeded = { [weak self] in
                self?.setUpgradesIfNeeded()
            }
            brain.multiplayerEnd = { [weak self] player in
                self?.multilayerEnd(player: player)
            }
        }
    }
    
    func setUpgradesIfNeeded() {
        brain.addMobsAndUpgrates()
        if let data = eventParser?.stringUpgrades(upgrades: brain.upgrades) {
            ConnectionServiceManager.shared.sendData(playerData: data)
        }
    }
    
    // Calls alert for approving home button event
    // and stop mobs and timers if it is single game
    func turnToHome() {
        if isSingleGame {
            brain.stopMobsMovement()
            singleplayerDetailsController?.stopTimer()
        }
        askUserIfNeedBackToHome()
    }
    
    // Creates alert for approving home button event
    // Precondition: Calls if on home button taped
    // Postcondition: if ok: invalidates timers in single game/ kills connection in multiplayer game
    func askUserIfNeedBackToHome() {
        let alert = UIAlertController(title: "Back to home",
                                      message: "Do you want to leave game?",
                                      preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if self?.isSingleGame ?? true {
                self?.brain.invalidateTimers()
            } else {
                ConnectionServiceManager.shared.killConnection()
            }
            self?.removeAllAdditionView()
            self?.dismiss(animated: true, completion: nil)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            if self?.isSingleGame ?? true {
                self?.changePause(state: false)
            }
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        self.present(alert, animated: true, completion:  nil)
    }
    
    func presentScore(score:Int) {
        singleplayerDetailsController?.present(score: Double(score))
    }
    
    func presentTimer(time: TimeInterval) {
        singleplayerDetailsController?.present(time: "\(time)")
    }
    
    func move(direction: Direction) {
        brain.move(to: direction, playerName: UIDevice.current.name)
        if !isSingleGame, let data = eventParser?.stringMoveEvent(name: UIDevice.current.name, direction: direction)  {
            ConnectionServiceManager.shared.sendData(playerData: data)
        }
    }
    
    func setBomb() {
        brain.plantBomb(playerName: UIDevice.current.name)
        if !isSingleGame, let data = eventParser?.stringBombEvent(name: UIDevice.current.name) {
            ConnectionServiceManager.shared.sendData(playerData: data)
        }
    }
    
    func timeEnd(state :Bool) {
        brain.score -= 1000
        if brain.score < 0 {
            brain.score = 0
        }
        gameEnd(didWin: !state)
    }
    
    // MARK: Prepare for segue block
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "singleplayerDetailsSegue",
            let controller = segue.destination as? SingleplayerDetailsController {
            prepareDetailsController(controller)
            multiplayerContainerView.removeFromSuperview()
            
        } else if segue.identifier == "multiplayerDetailsSegue",
            let controller = segue.destination as? MultiplayerDetailsController {
            prepareMultiplayerDetailsController(controller)
            
        } else if segue.identifier == "gameMapSegue",
            let controller = segue.destination as? GameMapController {
            controller.singleGame = isSingleGame
            gameMapController = controller
            
        } else if segue.identifier == "controlPanelSegue",
            let controller = segue.destination as? ControlPanelController {
            prepareControlPanelController(controller: controller)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "multiplayerDetailsSegue" && isSingleGame == true) ||
            (identifier == "singleplayerDetailsSegue" && isSingleGame == false) {
            return false
        }
        
        return true
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
    
    // Binds methods between details and game scene
    func prepareDetailsController(_ controller: SingleplayerDetailsController) {
        singleplayerDetailsController = controller
        
        singleplayerDetailsController?.onPauseTap = { [weak self] state in
            self?.changePause(state: state)
        }
        
        singleplayerDetailsController?.onHomeTap = { [weak self] in
            self?.turnToHome()
            
        }
        singleplayerDetailsController?.timeOver = { [weak self]  state in
            self?.timeEnd(state: state)
        }
    }
    
    // Binds methods between details and game scene
    func prepareMultiplayerDetailsController(_ controller: MultiplayerDetailsController) {
        multiplayerDetailsController = controller
        
        multiplayerDetailsController?.onHomeTap = { [weak self] in
            self?.turnToHome()
        }
    }
    
    // MARK: View did load block
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindBrainClosures()
        brain.isSingleGame = isSingleGame
        prepareMultiplayergameIfNeeded()
        
    }
    
    func bindBrainClosures() {
        brain.gameEnd = { [weak self] didWin in
            self?.gameEnd(didWin: didWin)
        }
        
        brain.presentTime = { [weak self] time in
            self?.presentTimer(time: time)
        }
        
        brain.refreshScore = { [weak self] score in
            self?.presentScore(score: score)
            
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

extension GameLayoutController: ConnectionServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ConnectionServiceManager, connectedDevices: [String]) {
        if connectedDevices.count == brain.players.count - 1 {
            var i = 0
            
            for player in brain.players {
                if !connectedDevices.contains(player.name), player.isAlive {
                    brain.killHero?(player.identifier, false)
                    brain.tiles[player.position].removeLast()
                    brain.players[i].isAlive = false
                }
                i += 1
            }
        }
    }
    
    func dataReceived(manager: ConnectionServiceManager, playerData: String) {
        let eventData: (name: String?, direction: Direction?, upgradeTypes: [String]?) = eventParser?.parseEvent(from: playerData) ?? (nil, nil, nil)
        if let direction = eventData.direction, let name = eventData.name {
            brain.move(to: direction, playerName: name)
            return
        }
        if let name = eventData.name {
            brain.plantBomb(playerName: name)
        }
        if let upgradeTypes = eventData.upgradeTypes {
            brain.getUpgrades(upgradeTypes: upgradeTypes)
        }
    }
    
    func connectionLost() {
        turnToHome()
    }
}

