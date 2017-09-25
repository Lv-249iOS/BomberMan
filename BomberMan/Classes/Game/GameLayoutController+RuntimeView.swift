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
            pause?.removeFromSuperview()
            pause = nil
            
        case .gameOver:
            gameOver?.removeFromSuperview()
            controlPanelController.setButtonState(isEnabled: true)
            gameOver = nil
            
        case .gameWin:
            gameWin?.removeFromSuperview()
            gameWin = nil
            
        case .nextLevel:
            moveToNextLevel?.removeFromSuperview()
            moveToNextLevel = nil
        }
    }
    
    func isGameEnd() -> Bool {
        return gameOver != nil || gameWin != nil
    }
    
    func removeAllAdditionView() {
        DispatchQueue.main.async { [weak self] in
            self?.pause?.removeFromSuperview()
            self?.gameOver?.removeFromSuperview()
            self?.controlPanelController.setButtonState(isEnabled: true)
            self?.gameWin?.removeFromSuperview()
            self?.moveToNextLevel?.removeFromSuperview()
            self?.pause = nil
            self?.gameOver = nil
            self?.gameWin = nil
            self?.moveToNextLevel = nil
        }
    }
}
