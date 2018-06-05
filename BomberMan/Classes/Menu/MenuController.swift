//
//  ViewController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/25/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var soundManager = SoundManager()
    var transition = CircularTransition()
    
    // Controls sound state
    @IBAction func onSoundTap(_ sender: UIButton) {
        soundManager.soundState = !soundManager.soundState
        set(soundState: soundManager.soundState)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(soundState: soundManager.soundState)
    }
    
    // Switchs on/off music
    func set(soundState: Bool) {
        if soundState {
            soundButton.setImage(#imageLiteral(resourceName: "soundOn"), for: .normal)
            soundManager.playMusic()
            
        } else {
            soundButton.setImage(#imageLiteral(resourceName: "soundOff"), for: .normal)
            soundManager.stopMusic()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue"{
            if let settingsVC = segue.destination as? SettingsController{
                settingsVC.transitioningDelegate = self
                settingsVC.modalPresentationStyle = .custom
            }
        }
    }
    
}

extension MenuController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.startingPoint = settingsButton.center
        transition.transitionMode = .present
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.startingPoint = settingsButton.center
        transition.transitionMode = .dismiss
        return transition
    }
}

