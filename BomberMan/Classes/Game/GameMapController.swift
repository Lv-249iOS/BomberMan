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
    private var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain.addPlayer(name: UIDevice.current.name)
        brain.initializeGame(with: 0, completelyNew: true)
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
        brain.redrawScene = { [weak self] in
            self?.drawMap()
        }
        brain.killHero = { [weak self] player, inPlace in
            self?.killHero(player: player, inPlace: inPlace)
        }
        brain.moveMob = { [weak self] direction, mob in
            self?.moveMob(in: direction, mob: mob)
        }
        brain.killMob = { [weak self] mob, inPlace in
            self?.killMob(mob: mob, inPlace: inPlace)
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
        sceneWidth = brain.width
        mapScroll.contentSize = CGSize(width: 50 * sceneWidth, height: 50 * (brain.tiles.count / sceneWidth))
        firstTime = true
        mobs.removeAll()
        players.removeAll()
        drawMap()
        let frame = CGRect(x: ((players.first?.frame.origin.x) ?? 0) - 150, y: ((players.first?.frame.origin.y) ?? 0) - 150, width: 350, height: 350)
        
        mapScroll.scrollRectToVisible(frame, animated: true)
        
    }
    
    func drawMap() {
        
        for subview in mapScroll.subviews {
            if let subImageView = subview as? UIImageView {
                if !players.contains(subImageView), !mobs.contains(subImageView), subImageView.tag != 66 {
                    subview.removeFromSuperview()
                }
            } else {
                subview.removeFromSuperview()
            }
            
        }
        
        var i = 0
        var j = 0
        var upgradeCounter = 0
        
        for tile in brain.tiles {
            for tileElement in tile {
                switch tileElement {
                case "W":
                    let rect = CGRect(x: i, y: j, width: 50, height: 50)
                    let wall = WallView(frame: rect)
                    wall.backgroundColor = UIColor.gray
                    mapScroll.addSubview(wall)
                case "B":
                    addSubBoxView(x: i, y: j)
                case "0":
                    if firstTime {
                        let rect = CGRect(x: i, y: j, width: 50, height: 50)
                        let player = UIImageView(frame: rect)
                        player.image = UIImage(named: "hero")
                        players.append(player)
                        if !players.isEmpty {
                            mapScroll.addSubview(players.last!)
                        }
                    }
                case "F":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "fire"))
                    
                case "X":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
                    
                case "Q":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
                    
                    let rect = CGRect(x: i, y: j, width: 50, height: 50)
                    let player = UIImageView(frame: rect)
                    player.image = UIImage(named: "hero")
                    players.last!.removeFromSuperview()
                    players.removeLast()
                    players.append(player)
                    mapScroll.addSubview(players.last!)
                case "M":
                    if firstTime {
                        let rect = CGRect(x: i, y: j, width: 50, height: 50)
                        let mob = UIImageView(frame: rect)
                        mob.image = #imageLiteral(resourceName: "balloon1")
                        mobs.append(mob)
                        if !mobs.isEmpty {
                            mapScroll.addSubview(mobs.last!)
                        }
                    }
                case "U":
                    let rect = CGRect(x: i, y: j, width: 50, height: 50)
                    let upgrages = brain.upgrades
                    switch upgrages[upgradeCounter].type {
                    case .anotherBomb:
                        addSubImageView(rect, image: #imageLiteral(resourceName: "bombupgrade"))
                    case .strongerBomb:
                        addSubImageView(rect, image: #imageLiteral(resourceName: "powerupgrade"))
                    }
                    upgradeCounter += 1
                case "D":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "door"))
                default:
                    break
                }
                
            }
            if i / 50 == sceneWidth - 1 {
                j += 50
                i = 0
            } else {
                i += 50
            }
            
        }
        
        firstTime = false
        
    }
    
    func kill(_ views: [UIImageView], pos: Int, inPlace: Bool) {
        let rect: CGRect!
        if inPlace {
            let layer = views[pos].layer.presentation()! as CALayer
            let frame = layer.frame
            rect = CGRect(x: frame.origin.x-25, y: frame.origin.y-25, width: 100, height: 100)
        }else {
            rect = CGRect(x: views[pos].frame.origin.x-25, y: views[pos].frame.origin.y-25, width: 100, height: 100)
        }
        //let layer = views[pos].layer.presentation()! as CALayer
        //let frame = layer.frame
        //let rect = CGRect(x: frame.origin.x-25, y: frame.origin.y-25, width: 100, height: 100) //CGRect(x: views[pos].frame.origin.x-25, y: views[pos].frame.origin.y-25, width: 100, height: 100)
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
        kill(mobs, pos: mob, inPlace: inPlace)
    }
    
    func killHero(player: Int, inPlace: Bool) {
        kill(players, pos: player, inPlace: inPlace)
    }
    
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
        }) { [weak self] finished in
            if finished {
                self?.animationCount += 1
                if self?.clickСount == self?.animationCount {
                    self?.players[player].stopAnimating()
                    self?.animationCount = 0
                    self?.clickСount = 0
                }
            }
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
    
    func animate(images:[UIImage], player: Int) {
        clickСount = 0
        animationCount = 0
        players[player].layer.removeAllAnimations()
        players[player].stopAnimating()
        
        players[player].animationImages = images
        players[player].animationDuration = 0.5
        players[player].startAnimating()
        
    }
    
    func addBomb(player: Int) {
        addSubImageView(CGRect(x: players[player].frame.origin.x, y: players[player].frame.origin.y, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
        
        mapScroll.willRemoveSubview(players[player])
        mapScroll.addSubview(players[player])
    }
    
    
    
}
