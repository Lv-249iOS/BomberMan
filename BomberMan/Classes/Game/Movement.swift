//
//  Movement.swift
//  BomberMan
//
//  Created by AndreOsip on 9/21/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
import UIKit

extension GameMapController {

    func moveMob(in direction: Direction, mob: Int) {
        
        switch direction {
        case .top:
            UIView.animate(withDuration: 1) { [weak self] in
                self?.mobs[mob].transform = (self?.mobs[mob].transform.translatedBy(x: 0, y: -50))!
            }
        case .bottom:
            UIView.animate(withDuration: 1) { [weak self] in
                self?.mobs[mob].transform = (self?.mobs[mob].transform.translatedBy(x: 0, y: 50))!
            }
        case .right:
            UIView.animate(withDuration: 1) { [weak self] in
                self?.mobs[mob].transform = (self?.mobs[mob].transform.translatedBy(x: 50, y: 0))!
            }
        case .left:
            UIView.animate(withDuration: 1) { [weak self] in
                self?.mobs[mob].transform = (self?.mobs[mob].transform.translatedBy(x: -50, y: 0))!
            }
        }
        
    }
    
    func move(in direction: Direction, player: Int) {
        switch direction {
        case .bottom:
            
            let downImageArray = (1...2).map { UIImage(named: "down\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage")  }
            if players[player].animationImages?.first != UIImage(named: "down\(player+1)1") && players[player].animationImages?.first != nil {
                
                animate(images: downImageArray, player: player)
            }
            animateImagesForMove(images: downImageArray, x: 0, y: 50, player: player)
            
        case .left:
            
            let leftImageArray = (1...3).map { UIImage(named: "left\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "left\(player+1)1") && players[player].animationImages?.first != nil {
                animate(images: leftImageArray, player: player)
            }
            animateImagesForMove(images: leftImageArray, x: -50, y: 0, player: player)
            
        case .right:
            
            let rightImageArray = (1...3).map { UIImage(named: "right\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "right\(player+1)1") && players[player].animationImages?.first != nil {
                
                animate(images: rightImageArray, player: player)
            }
            animateImagesForMove(images: rightImageArray, x: 50, y: 0, player: player)
            
        case .top:
            
            let upImageArray = (1...3).map { UIImage(named: "up\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "up\(player+1)1") && players[player].animationImages?.first != nil {
                
                animate(images: upImageArray, player: player)
            }
            animateImagesForMove(images: upImageArray, x: 0, y: -50, player: player)
        }
        //HEARE
        clickСount[player] += 1
        //if this player is me -> scroll
        if brain.players[player].name == UIDevice.current.name {
            let frame = CGRect(x: players[player].frame.origin.x-150, y: players[player].frame.origin.y-150, width: players[player].frame.width*6, height: players[player].frame.height*6)
            
            mapScroll.scrollRectToVisible(frame, animated: true)
        }
    }
    
    func animateImagesForMove(images: [UIImage],x: CGFloat,y: CGFloat, player: Int){
        let options  = UIViewAnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: 0.5, delay: 0, options: options, animations: {[weak self] in
            if !(self?.players[player].isAnimating)! {
                self?.players[player].animationImages = images
                self?.players[player].animationDuration = 0.5
                self?.players[player].startAnimating()
            }
            self?.players[player].transform = (self?.players[player].transform.translatedBy(x: x, y: y))!
        }) { [weak self] finished in
            if finished {
                self?.animationCount[player] += 1
                ///HEARE
                if self?.clickСount[player] == self?.animationCount[player] {
                    self?.players[player].stopAnimating()
                    self?.animationCount[player] = 0
                    self?.clickСount[player] = 0
                }
            }
        }
    }


    func animate(images:[UIImage], player: Int) {
        //HEARE
        clickСount[player] = 0
        animationCount[player] = 0
        players[player].layer.removeAllAnimations()
        players[player].stopAnimating()
        
        players[player].animationImages = images
        players[player].animationDuration = 0.5
        players[player].startAnimating()
        
    }

}
