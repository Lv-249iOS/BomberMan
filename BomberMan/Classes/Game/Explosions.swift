//
//  Explosions.swift
//  BomberMan
//
//  Created by AndreOsip on 9/21/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
import UIKit

extension GameMapController {
    
    func kill(_ views: [UIImageView], pos: Int, inPlace: Bool) {
        let rect: CGRect!
        if inPlace {
            let layer = views[pos].layer.presentation()! as CALayer
            let frame = layer.frame
            rect = CGRect(x: frame.origin.x-25, y: frame.origin.y-25, width: 100, height: 100)
        }else {
            rect = CGRect(x: views[pos].frame.origin.x-25, y: views[pos].frame.origin.y-25, width: 100, height: 100)
        }
        let death = UIImageView(frame: rect)
        mapScroll.addSubview(death)
        death.tag = 66
        
        views[pos].removeFromSuperview()
        
        death.animationImages = (1...8).map { UIImage(named: "death\($0)") ?? #imageLiteral(resourceName: "noImage") }
        death.animationRepeatCount = 1
        death.animationDuration = 1
        death.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in
            death.removeFromSuperview()
        }
    }
    
    func killMob(mob:Int, inPlace: Bool) {
        brain.currentTime += 10
        kill(mobs, pos: mob, inPlace: inPlace)
    }
    
    func killHero(player: Int, inPlace: Bool) {
        kill(players, pos: player, inPlace: inPlace)
    }
    
    func boxExplosion(pos: Int) {
        
        let x = pos % brain.width * 50
        let y = pos / brain.width * 50
        
        let rect = CGRect(x: x-25, y: y-25, width: 100, height: 100)
        
        let explode = UIImageView(frame: rect)
        mapScroll.addSubview(explode)
        explode.tag = 66
        
        explode.animationImages = (1...6).map { UIImage(named: "boxExplosion\($0)") ?? #imageLiteral(resourceName: "noImage") }
        explode.animationRepeatCount = 1
        explode.animationDuration = 0.7
        explode.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) {_ in
            explode.removeFromSuperview()
        }
        
    }

    func explode(ranges: Explosion, center: Int) {
        drawMap()
        
        let x = center % brain.width * 50
        let y = center / brain.width * 50
        
        let left = ranges.left
        let right = ranges.right
        let up = ranges.top
        let down = ranges.bottom
        
        func chackForIntersection(_ mob: UIImageView, x: CGFloat, y: CGFloat) {
            
            if let index = mobs.index(of: mob) {
                let rect = CGRect(x: x, y: y, width: 50, height: 50)
                let layer = mob.layer.presentation()! as CALayer
                let frame = layer.frame
                if frame.intersects(rect){
                    for brainMob in brain.mobs {
                        if let indexOfMobInBrain = brain.getMobIndexInPrivateArray(mob: brainMob) {
                            if brainMob.identifier == index {
                                if !brain.tiles[brain.mobs[indexOfMobInBrain].position].isEmpty,
                                    brain.tiles[brain.mobs[indexOfMobInBrain].position].last == "M" {
                                    brain.tiles[brain.mobs[indexOfMobInBrain].position].removeLast()
                                    kill(mobs, pos: index, inPlace: true)
                                    brain.mobs.remove(at: indexOfMobInBrain)
                                    brain.score += ScoreBoosts.mobKill.rawValue
                                    brain.currentTime += 10
                                    brain.refreshScore?(brain.score)
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
        for mob in mobs {
            for i in stride(from: x-left*50, through: x+right*50, by: 50) {
                chackForIntersection(mob, x: CGFloat(i), y: CGFloat(y))
                
            }
            for i in stride(from: y-up*50, through: y+down*50, by: 50) {
                chackForIntersection(mob, x: CGFloat(x), y: CGFloat(i))
            }
            
        }
    }


}
