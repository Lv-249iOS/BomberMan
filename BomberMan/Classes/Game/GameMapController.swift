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
    
    private var map: String!
    private var sceneWidth: Int!
    private var players: [UIImageView] = []
    private var mobs: [UIImageView] = []
    private var clickСount = 0
    private var animationCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain.initializeGame(with: 0)
        updateContentSize()
        
        brain.showFire = { [weak self] explosion, center in
            self?.explode(ranges: explosion, center: center)
        }
        brain.move = { [weak self] direction, player in
            self?.move(in: direction, player: player)
        }
        brain.plantBomb = { [weak self] player in
            self?.addBomb(player: player)
        }
        brain.redrawScene = { [weak self] _ in
            self?.drawMap()
        }
        brain.killHero = { [weak self] player in
            self?.killHero(player: player)
        }
        brain.moveMob = { [weak self] direction, mob in
            self?.moveMob(in: direction, mob: mob)
        }
        brain.killMob = { [weak self] mob in
            self?.killMob(mob: mob)
        }
    }
    
    func addSubImageView(_ rect: CGRect, image: UIImage) {
        let imageSub = UIImageView(frame: rect)
        imageSub.image = image
        mapScroll.addSubview(imageSub)
    }
    
    func addSubBoxView(x: Int, y: Int) {
        let rect = CGRect(x: x, y: y, width: 50, height: 50)
        let box = BoxView(frame: rect)
        box.backgroundColor = UIColor.brown
        mapScroll.addSubview(box)
    }
    
    func updateContentSize() {
        map = brain.shareScene().data
        sceneWidth = brain.shareScene().width
        
        mapScroll.contentSize = CGSize(width: 50 * sceneWidth, height: 50 * (map.characters.count / sceneWidth))
        drawMap()
    }
    
    func drawMap() {

        for subview in mapScroll.subviews {
            subview.removeFromSuperview()
        }
        mobs.removeAll()
        
        let sceneWidth = brain.shareScene().width
        map = brain.shareScene().data
        
        var i = 0
        var j = 0
        var upgradeCounter = 0
        
        for tile in map.characters {
            
            switch tile {
            case "W":
                let rect = CGRect(x: i, y: j, width: 50, height: 50)
                let wall = WallView(frame: rect)
                wall.backgroundColor = UIColor.gray
                mapScroll.addSubview(wall)
            case "B":
                addSubBoxView(x: i, y: j)
            case "0":
                let rect = CGRect(x: i, y: j, width: 50, height: 50)
                let player = UIImageView(frame: rect)
                players.append(player)
                players[0].image = UIImage(named: "hero")
                mapScroll.addSubview(players[0])
            case "F":
                addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "fire"))
                
            case "X":
                addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
                
            case "Q":
                addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
                
                let rect = CGRect(x: i, y: j, width: 50, height: 50)
                let player = UIImageView(frame: rect)
                player.image = UIImage(named: "hero")                
                players.append(player)
                mapScroll.addSubview(players.last!)
            case "M":
                let rect = CGRect(x: i, y: j, width: 50, height: 50)
                let mob = UIImageView(frame: rect)
                mob.image = #imageLiteral(resourceName: "balloon1")
                mobs.append(mob)
                mob.tag = brain.shareMobs()[mobs.count - 1]
                mapScroll.addSubview(mobs.last!)
            case "U":
                let rect = CGRect(x: i, y: j, width: 50, height: 50)
                let upgrages = brain.upgrades
                if upgrages[upgradeCounter].health == 1 {
                    addSubImageView(rect, image: #imageLiteral(resourceName: "Medal"))
                } else {
                    addSubBoxView(x: i, y: j)
                }
                upgradeCounter += 1
            case "D":
                if brain.door.health == 1 {
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "door"))
                } else {
                    addSubBoxView(x: i, y: j)
                }
            default:
                break
            }
            
            if i / 50 == sceneWidth-1 {
                j += 50
                i = 0
            } else {
                i += 50
            }
        }
        
    }
    
    func kill(_ views: [UIImageView], pos: Int) {
        let rect = CGRect(x: views[pos].frame.origin.x, y: views[pos].frame.origin.y, width: 50, height: 50)
        let death = UIImageView(frame: rect)
        mapScroll.addSubview(death)
        
        views[pos].removeFromSuperview()
        
        death.animationImages = (1...8).map { UIImage(named: "death\($0)") ?? #imageLiteral(resourceName: "noImage") }
        death.animationRepeatCount = 1
        death.animationDuration = 1
        death.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            death.removeFromSuperview()
        })
    }
    
    func killMob(mob:Int) {
        var i = 0
        for a in mobs {
            if a.tag == mob {
            kill(mobs, pos: i)
            }
            i += 1
        }
    }
    
    func killHero(player: Int) {
        kill(players, pos: player)
    }
    
    func moveMob(in direction: Direction, mob: Int) {
        var i = 0
        for a in mobs {
            if a.tag == mob {
                break
            }
            i += 1
        }
        switch direction {
        case .top:
            UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.mobs[i].transform = (self?.mobs[i].transform.translatedBy(x: 0, y: -50))!
            })
        case .bottom:
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.mobs[i].transform = (self?.mobs[i].transform.translatedBy(x: 0, y: 50))!
            })
        case .right:
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.mobs[i].transform = (self?.mobs[i].transform.translatedBy(x: 50, y: 0))!
            })
        case .left:
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.mobs[i].transform = (self?.mobs[i].transform.translatedBy(x: -50, y: 0))!
            })
        }
    
    }
    
    func move(in direction: Direction, player: Int) {
        switch direction {
        case .bottom:
            
            let downImageArray = (1...5).map { UIImage(named: "down\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage")  }
            if players[player].animationImages?.first != UIImage(named: "down\(player+1)1") && players[player].animationImages?.first != nil {
                
                animate(images: downImageArray, player: player)
            }
            animateImagesForMove(images: downImageArray, x: 0, y: 50, player: player)
            
        case .left:
            
            let leftImageArray = (1...5).map { UIImage(named: "left\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "left\(player+1)1") && players[player].animationImages?.first != nil {
                animate(images: leftImageArray, player: player)
            }
            animateImagesForMove(images: leftImageArray, x: -50, y: 0, player: player)
            
        case .right:
            
            let rightImageArray = (1...5).map { UIImage(named: "right\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "right\(player+1)1") && players[player].animationImages?.first != nil {

                animate(images: rightImageArray, player: player)
            }
            animateImagesForMove(images: rightImageArray, x: 50, y: 0, player: player)
            
        case .top:
            
            let upImageArray = (1...5).map { UIImage(named: "up\(player+1)\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "up\(player+1)1") && players[player].animationImages?.first != nil {
                
                animate(images: upImageArray, player: player)
            }
            animateImagesForMove(images: upImageArray, x: 0, y: -50, player: player)
        }
        
        clickСount += 1
        
        let frame = CGRect(x: players[player].frame.origin.x-150, y: players[player].frame.origin.y-150, width: players[player].frame.width*6, height: players[player].frame.height*6)
        
        mapScroll.scrollRectToVisible(frame, animated: true)
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
            }, completion: { [weak self] finished in
                if finished {
                    self?.animationCount += 1
                    if self?.clickСount == self?.animationCount {
                        self?.players[player].stopAnimating()
                        self?.animationCount = 0
                        self?.clickСount = 0
                    }
                }
        })
    }
    
    func explode(ranges: Explosion, center: String.Index) {
        
        map = brain.shareScene().data
        drawMap()
        
        let intValue = map.distance(from: map.startIndex, to: center)
        let x = intValue % brain.shareScene().width * 50
        let y = intValue / brain.shareScene().width * 50
        
        var left = ranges.left
        var right = ranges.right
        var up = ranges.top
        var down = ranges.bottom
        
        if left >= 0 {
            while left >= 0 {
                addSubImageView(CGRect(x: x - left*50, y: y, width: 50, height: 50), image: #imageLiteral(resourceName: "fire"))
                left -= 1
            }
        }
        if right > 0 {
            while right > 0 {
                addSubImageView(CGRect(x: x + right*50, y: y, width: 50, height: 50), image: #imageLiteral(resourceName: "fire"))
                right -= 1
            }
        }
        if up > 0 {
            while up > 0 {
                addSubImageView(CGRect(x: x , y: y - up*50, width: 50, height: 50), image: #imageLiteral(resourceName: "fire"))
                up -= 1
            }
        }
        if down > 0 {
            while down > 0 {
                addSubImageView(CGRect(x: x , y: y + down*50, width: 50, height: 50), image: #imageLiteral(resourceName: "fire"))
                down -= 1
            }
        }
    }
    
    func animate(images:[UIImage], player: Int) {
        clickСount = 0
        animationCount = 0
        players[player].stopAnimating()
        players[player].animationImages = images
        players[player].animationDuration = 0.5
        players[player].startAnimating()
        players[player].layer.removeAllAnimations()
    }
    
    func addBomb(player: Int) {
        addSubImageView(CGRect(x: players[player].frame.origin.x, y: players[player].frame.origin.y, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
        
        mapScroll.willRemoveSubview(players[player])
        mapScroll.addSubview(players[player])
    }
    
    
    
}