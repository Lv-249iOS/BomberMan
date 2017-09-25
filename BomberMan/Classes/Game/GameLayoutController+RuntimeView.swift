//
//  GameLayoutController+RuntimeView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/15/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

extension GameLayoutController {
    
    func createPauseView() {
        controlPanelController.setButtonState(isEnabled: false)
        pause = PauseView(frame: gameMapController.mapScroll.frame)
        
        pause?.onPauseButtTap = { [weak self] in
            self?.changePause(state: false)
        }
    }
    
    func createGameWinView() {
        controlPanelController.setButtonState(isEnabled: false)
        gameWin = WinView(frame: gameMapController.mapScroll.frame)
        
        if !isSingleGame {
            gameWin?.hideButtons()
            
        } else {
            gameWin?.onBackToHomeTap = { [weak self] in
                self?.turnToHome()
            }
            
            gameWin?.onReplayGameTap = { [weak self] in
                self?.replayGame()
            }
            
            gameWin?.onShowRatingTap = { [weak self] in
                self?.moveToRating()
            }
        }
    }
    
    func createGameOverView() {
        controlPanelController.setButtonState(isEnabled: false)
        gameOver = GameOverView(frame: gameMapController.mapScroll.frame)
        
        if !isSingleGame {
            gameOver?.hideRepeatButton()
            gameOver?.setLabel(text: "You lose!")
            
        } else {
            gameOver?.onRepeatButtTap = { [weak self] in
                self?.replayLevel(isGameOver: true)
            }
        }
    }
    
    func createMoveToNextLevelView() {
        controlPanelController.setButtonState(isEnabled: false)
        moveToNextLevel = MoveToNextLevelView(frame: gameMapController.mapScroll.frame)
        
        moveToNextLevel?.onMoveOnButtTap = { [weak self] in
            self?.moveToNextLvl()
        }
        
        moveToNextLevel?.onRepeatButtTap = { [weak self] in
            self?.replayLevel(isGameOver: false)
        }
    }
    
    /// Precondition: gets type of addition view
    /// Postcondition: remove it from superview
    /// sets this view to nil
    func removeAdditionView(additionView: AdditionView) {
        controlPanelController.setButtonState(isEnabled: true)
        switch additionView {
        case .pause:
            DispatchQueue.main.async { [weak self] in
                self?.pause?.removeFromSuperview()
                self?.pause = nil
            }
            
        case .gameOver:
            DispatchQueue.main.async { [weak self] in
                self?.gameOver?.removeFromSuperview()
                self?.controlPanelController.setButtonState(isEnabled: true)
                self?.gameOver = nil
            }
            
        case .gameWin:
            DispatchQueue.main.async { [weak self] in
                self?.gameWin?.removeFromSuperview()
                self?.gameWin = nil
            }
            
        case .nextLevel:
            DispatchQueue.main.async { [weak self] in
                self?.moveToNextLevel?.removeFromSuperview()
                self?.moveToNextLevel = nil
            }
        }
    }
    
    func isGameEnd() -> Bool {
        return gameOver != nil || gameWin != nil
    }
    
    func removeAllAdditionView() {
        pause?.removeFromSuperview()
        gameOver?.removeFromSuperview()
        controlPanelController.setButtonState(isEnabled: true)
        gameWin?.removeFromSuperview()
        moveToNextLevel?.removeFromSuperview()
        pause = nil
        gameOver = nil
        gameWin = nil
        moveToNextLevel = nil
    }
}
