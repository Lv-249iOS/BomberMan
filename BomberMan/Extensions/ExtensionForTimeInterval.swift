//
//  ExtensionForTimeInterval.swift
//  MemoryTracker
//
//  Created by Kristina Del Rio Albrechet on 8/31/17.
//
//

import UIKit

extension TimeInterval {
    
    static func toString(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
