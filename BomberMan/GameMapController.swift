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
    private var clickСount = 0
    private var animationCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = brain.shareScene().data
        sceneWidth = brain.shareScene().width

        mapScroll.contentSize = CGSize(width: 50 * sceneWidth, height: 50 * (map.characters.count / sceneWidth))
        
        drawMap()
        
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
    }
    
    func drawMap() {
        
        for subview in mapScroll.subviews {
        subview.removeFromSuperview()
        }
        map = brain.shareScene().data
        let sideTilesCount = sqrt(Double(map.characters.count))
        
        var ii = 0
        var jj = 0
        
        for i in map.characters {
            
            switch i {
            case "W":
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let wall = WallView(frame: rect)
                wall.backgroundColor = UIColor.gray
                mapScroll.addSubview(wall)
            case "B":
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let box = BoxView(frame: rect)
                box.backgroundColor = UIColor.brown
                mapScroll.addSubview(box)
            case "0":
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let player = UIImageView(frame: rect)
                players.append(player)
                players[0].image = UIImage(named: "hero")
                mapScroll.addSubview(players[0])
            case "F":
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let fire = UIImageView(frame: rect)
                fire.image = #imageLiteral(resourceName: "fire")
                mapScroll.addSubview(fire)
            case "X":
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let bomb = UIImageView(frame: rect)
                bomb.image = #imageLiteral(resourceName: "bomb")
                mapScroll.addSubview(bomb)
            default:
                break
            }
            
            if ii / 50 == Int(sideTilesCount-1) {
                jj += 50
                ii = 0
            } else {
                ii += 50
            }
        }
    
    }
    
    func killHero(player: Int) {
        let rect = CGRect(x: players[player].frame.origin.x, y: players[player].frame.origin.y, width: 50, height: 50)
        let death = UIImageView(frame: rect)
        
        players[player].removeFromSuperview()
        
        death.animationImages = (1...8).map { UIImage(named: "death\($0)") ?? #imageLiteral(resourceName: "noImage") }
        death.animationRepeatCount = 1
        death.animationDuration = 1
        death.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            death.removeFromSuperview()
        })
        
    }
    
    func move(in direction: Direction, player: Int) {
        switch direction {
        case .bottom:
            let downImageArray = (1...5).map { UIImage(named: "down\($0)") ?? #imageLiteral(resourceName: "noImage")  }
            if players[player].animationImages?.first != UIImage(named: "down1") && players[player].animationImages?.first != nil {
                
                animate(images: downImageArray, player: player)
            }
            animateImagesForMove(images: downImageArray, x: 0, y: 50, player: player)
            
        case .left:
            let leftImageArray = (1...5).map { UIImage(named: "left\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "left1") && players[player].animationImages?.first != nil {
                animate(images: leftImageArray, player: player)
            }
            animateImagesForMove(images: leftImageArray, x: -50, y: 0, player: player)
            
        case .right:
            let rightImageArray = (1...5).map { UIImage(named: "right\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "right1") && players[player].animationImages?.first != nil{
                
                animate(images: rightImageArray, player: player)
            }
            animateImagesForMove(images: rightImageArray, x: 50, y: 0, player: player)
            
        case .top:
            let upImageArray = (1...5).map { UIImage(named: "up\($0)") ?? #imageLiteral(resourceName: "noImage") }
            if players[player].animationImages?.first != UIImage(named: "up1") && players[player].animationImages?.first != nil {
                
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
        let rect = CGRect(x: players[player].frame.origin.x, y: players[player].frame.origin.y, width: 50, height: 50)
        let bomb = UIImageView(frame: rect)
        bomb.image = #imageLiteral(resourceName: "bomb")
        mapScroll.addSubview(bomb)
        mapScroll.willRemoveSubview(players[player])
        mapScroll.addSubview(players[player])
    }
    
    
    
}
