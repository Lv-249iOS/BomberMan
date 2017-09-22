//
//  Protocols.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/15/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

protocol GameTimer {
    
    func runTimer()
    func stopTimer()
    func resetTimer()
    func changeTimerState()
    func presentTimer()
}
