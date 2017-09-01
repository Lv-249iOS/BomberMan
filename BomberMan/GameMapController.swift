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
        
        
        
        let sideTilesCount = sqrt(Double(map.characters.count))
        mapScroll.contentSize = CGSize(width: 50 * sideTilesCount, height: 50 * sideTilesCount)
        
        drawMap()
        
        brain.showFire = { [weak self] explosion, center in
            self?.explode(ranges: explosion, center: center)
        }
    }
    
    func drawMap() {
        
        for i in mapScroll.subviews {
        i.removeFromSuperview()
        }
    
        let sideTilesCount = sqrt(Double(map.characters.count))
        
        var ii = 0
        var jj = 0
        
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
            let frame = CGRect(x: hero.frame.origin.x-100, y: hero.frame.origin.y-100, width: hero.frame.width*5, height: hero.frame.height*5)
            
            mapScroll.scrollRectToVisible(frame, animated: true)
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
    
    func explode(ranges: Explosion, center: String.Index) {
        map = brain.shareScene()
        drawMap()
        
        let intValue = map.distance(from: map.startIndex, to: center)
        let x = intValue%10 * 50
        let y = intValue / 10 * 50
        var left = ranges.left
        var right = ranges.right
        var up = ranges.top
        var down = ranges.bottom
        
        let rect = CGRect(x: x, y: y, width: 50, height: 50)
        let fire = UIImageView(frame: rect)
        fire.image = #imageLiteral(resourceName: "fire")
        mapScroll.addSubview(fire)
        
        if left > 0 {
            while left > 0 {
                let rect = CGRect(x: x - left*50, y: y, width: 50, height: 50)
                let fire = UIImageView(frame: rect)
                fire.image = #imageLiteral(resourceName: "fire")
                mapScroll.addSubview(fire)
                left -= 1
            }
        }
        if right > 0 {
            while right > 0 {
                let rect = CGRect(x: x + right*50, y: y, width: 50, height: 50)
                let fire = UIImageView(frame: rect)
                fire.image = #imageLiteral(resourceName: "fire")
                mapScroll.addSubview(fire)
                right -= 1
            }
        }
        if up > 0 {
            while up > 0 {
                let rect = CGRect(x: x , y: y - up*50 , width: 50, height: 50)
                let fire = UIImageView(frame: rect)
                fire.image = #imageLiteral(resourceName: "fire")
                mapScroll.addSubview(fire)
                up -= 1
            }
        }
        if down > 0 {
            while down > 0 {
                let rect = CGRect(x: x , y: y + down * 50, width: 50, height: 50)
                let fire = UIImageView(frame: rect)
                fire.image = #imageLiteral(resourceName: "fire")
                mapScroll.addSubview(fire)
                down -= 1
            }
        }
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
