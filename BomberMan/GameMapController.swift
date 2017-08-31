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
    
    var map: String!
    var orc: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = "WWWWWWWWWWW  P     WW        WW        WW  B BBB WW  B B   WW  BBBBB WW    B B WW  BBB B WWWWWWWWWWW"
        
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
                orc = UIImageView(frame: rect)
                orc.image = UIImage(named: "hero")
                mapScroll.addSubview(orc)
                
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
                let downImageArray = (1...5).map { UIImage(named: "down\($0)")! }
                animateImages(images: downImageArray, x: 0, y: 50)
                orc.image = UIImage(named: "down1")
            case .left:
                let leftImageArray = (1...5).map { UIImage(named: "left\($0)")! }
                animateImages(images: leftImageArray, x: -50, y: 0)
                orc.image = UIImage(named: "left1")
            case .right:
                let rightImageArray = (1...5).map { UIImage(named: "right\($0)")! }
                animateImages(images: rightImageArray, x: 50, y: 0)
                orc.image = UIImage(named: "right1")
            case .top:
                let upImageArray = (1...5).map { UIImage(named: "up\($0)")! }
                animateImages(images: upImageArray, x: 0, y: -50)
                orc.image = UIImage(named: "up1")
            }
        }
    }
    
    func animateImages(images:[UIImage],x:CGFloat,y:CGFloat){
        let op  = UIViewAnimationOptions.beginFromCurrentState
        
        UIView.animate(withDuration: 0.5, delay: 0, options: op, animations: {[weak self] in
            
            if !(self?.orc.isAnimating)! {
                
                self?.orc.animationImages = images
                self?.orc.animationDuration = 0.5
                self?.orc.startAnimating()
            }
            
            self?.orc.transform = (self?.orc.transform.translatedBy(x: x, y: y))!
            }, completion: { [weak self] finished in
                
            if finished {
                self?.orc.stopAnimating()
            }
        })
        
    }
    
}
