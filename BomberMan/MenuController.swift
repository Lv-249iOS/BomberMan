//
//  ViewController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/25/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit
import AVFoundation

class MenuController: UIViewController {
    
    @IBOutlet weak var soundButton: UIButton!
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func onSoundTap(_ sender: UIButton) {
        setSoundIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "soundState") as? Bool == nil {
            UserDefaults.standard.set(false, forKey: "soundState")
        }
        
        initMelody()
        setSoundIfNeeded()
    }
    
    func setSoundIfNeeded() {
        if let soundState = UserDefaults.standard.value(forKey: "soundState") as? Bool {
            if soundState != true {
                soundButton.setImage(#imageLiteral(resourceName: "soundOn"), for: .normal)
                audioPlayer.play()
                
            } else {
                soundButton.setImage(#imageLiteral(resourceName: "soundOff"), for: .normal)
                audioPlayer.stop()
            }
            
            UserDefaults.standard.set(!soundState, forKey: "soundState")
        }
    }
    
    func initMelody() {
        do {
            if let musicFile = Bundle.main.path(forResource: "opening", ofType: "mp3") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicFile))
            }
            
        } catch {
            print(error)
        }
    }
}

