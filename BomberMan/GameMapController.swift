//
//  GameMapController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class GameMapController: UIViewController {
    
    @IBOutlet weak var mapScroll: UIScrollView!
    
    let brain = Brain.shared
    
    var map: String!
    var hero: UIImageView!
    var clickСount = 0
    var animationCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = brain.shareScene()
        
        var ii = 0
        var jj = 0
        
        let sideTilesCount = sqrt(Double(map.characters.count))
        
        mapScroll.contentSize = CGSize(width: 50 * sideTilesCount, height: 50 * sideTilesCount)
        
        for i in map.characters {
            if i == "W" {
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let wall = WallView(frame: rect)
                wall.backgroundColor = UIColor.gray
                mapScroll.addSubview(wall)
                
            } else if i == "B" {
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let box = BoxView(frame: rect)
                box.backgroundColor = UIColor.brown
                mapScroll.addSubview(box)
                
            } else if i == "P" {
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                hero = UIImageView(frame: rect)
                hero.image = UIImage(named: "hero")
                mapScroll.addSubview(hero)
                
            }
            
            if ii / 50 == Int(sideTilesCount-1) {
                jj += 50
                ii = 0
            } else {
                ii += 50
            }
        }
    }
    
    func move(in direction: Direction) {
        if Brain.shared.move(to: direction, player: Player()) {
            switch direction {
            case .bottom:
                let downImageArray = (1...5).map { UIImage(named: "down\($0)") ?? #imageLiteral(resourceName: "noImage")  }
                if hero.animationImages?.first != UIImage(named: "down1") && hero.animationImages?.first != nil {
                    
                    animate(images: downImageArray)
                }
                animateImagesforMove(images: downImageArray, x: 0, y: 50)
                
            case .left:
                let leftImageArray = (1...5).map { UIImage(named: "left\($0)") ?? #imageLiteral(resourceName: "noImage") }
                if hero.animationImages?.first != UIImage(named: "left1") && hero.animationImages?.first != nil {
                    animate(images: leftImageArray)
                }
                animateImagesforMove(images: leftImageArray, x: -50, y: 0)
                
            case .right:
                let rightImageArray = (1...5).map { UIImage(named: "right\($0)") ?? #imageLiteral(resourceName: "noImage") }
                if hero.animationImages?.first != UIImage(named: "right1") && hero.animationImages?.first != nil{
                    
                    animate(images: rightImageArray)
                }
                animateImagesforMove(images: rightImageArray, x: 50, y: 0)
                
            case .top:
                let upImageArray = (1...5).map { UIImage(named: "up\($0)") ?? #imageLiteral(resourceName: "noImage") }
                if hero.animationImages?.first != UIImage(named: "up1") && hero.animationImages?.first != nil {
                    
                    animate(images: upImageArray)
                }
                animateImagesforMove(images: upImageArray, x: 0, y: -50)
            }
            clickСount += 1
        }
    }
    
    func animateImagesforMove(images:[UIImage],x:CGFloat,y:CGFloat){
        let op  = UIViewAnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: 0.5, delay: 0, options: op, animations: {[weak self] in
            if !(self?.hero.isAnimating)! {
                self?.hero.animationImages = images
                self?.hero.animationDuration = 0.5
                self?.hero.startAnimating()
            }
            self?.hero.transform = (self?.hero.transform.translatedBy(x: x, y: y))!
            }, completion: { [weak self] finished in
                if finished {
                    self?.animationCount += 1
                    if self?.clickСount == self?.animationCount {
                        self?.hero.stopAnimating()
                        self?.animationCount = 0
                        self?.clickСount = 0
                        
                        
                        
                    }
                }
        })
    }
    
    func animate(images:[UIImage]) {
        clickСount = 0
        animationCount = 0
        hero.stopAnimating()
        hero.animationImages = images
        hero.animationDuration = 0.5
        hero.startAnimating()
        hero.layer.removeAllAnimations()
    }
    
    func addBomb() {
        if brain.plantBomb() {
            let rect = CGRect(x: hero.frame.origin.x, y: hero.frame.origin.y, width: 50, height: 50)
            let bomb = UIImageView(frame: rect)
            bomb.image = #imageLiteral(resourceName: "bomb")
            mapScroll.addSubview(bomb)
            mapScroll.willRemoveSubview(hero)
            mapScroll.addSubview(hero)
        }
    }
    
}
