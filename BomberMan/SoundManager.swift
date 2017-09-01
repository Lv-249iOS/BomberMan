//
//  SoundManager.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import AVFoundation

class SoundManager {
    
    enum Sound: String {
        case state = "soundState"
        case name = "melody"
        case type = "mp3"
    }
    
    var player: AVAudioPlayer?
    
    init() {
        player = AVAudioPlayer()
        setMelody(name: Sound.name.rawValue, type: Sound.type.rawValue)
        
        // in firts launch app value will be nil
        if UserDefaults.standard.value(forKey: Sound.state.rawValue) as? Bool == nil {
            UserDefaults.standard.set(true, forKey: Sound.state.rawValue)
        }
    }
    
    /// Set & Get value of state into user defaults
    var soundState: Bool {
        get {
            return UserDefaults.standard.value(forKey: Sound.state.rawValue) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Sound.state.rawValue)
        }
    }
    
    /// Starts playing music
    func playMusic() {
        player?.play()
    }
    
    /// Stops playing music
    func stopMusic() {
        player?.stop()
    }
    
    /// Sets melody for playing with name nad type of music
    func setMelody(name: String, type: String) {
        if let musicFile = Bundle.main.path(forResource: name, ofType: type) {
            player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicFile))
        }
    }
}
