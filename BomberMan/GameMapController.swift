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
            self.orc.animationRepeatCount = 1
            
            switch direction {
            case .bottom:
            let loadingImages = (1...5).map { UIImage(named: "down\($0)")! }
            self.orc.animationImages = loadingImages
            self.orc.animationDuration = 0.5
            
            self.orc.startAnimating()
            orc.transform = (self.orc.transform.translatedBy(x: 0, y: 50))
                
            case .left:
            let loadingImages = (1...5).map { UIImage(named: "left\($0)")! }
            self.orc.animationImages = loadingImages
            self.orc.animationDuration = 0.5
            self.orc.startAnimating()
            orc.transform = (self.orc.transform.translatedBy(x: -50, y: 0))
           
            case .right:
            let loadingImages = (1...5).map { UIImage(named: "right\($0)") ?? #imageLiteral(resourceName: "noimage") }
            self.orc.animationImages = loadingImages
            self.orc.animationDuration = 0.5
            self.orc.startAnimating()
            orc.transform = (self.orc.transform.translatedBy(x: 50, y: 0))
                
            case .top:
            let loadingImages = (1...5).map { UIImage(named: "up\($0)") ?? #imageLiteral(resourceName: "noimage") }
            self.orc.animationImages = loadingImages
            self.orc.animationDuration = 0.5
            self.orc.startAnimating()
            orc.transform = (self.orc.transform.translatedBy(x: 0, y: -50))
            }
        }
        
    }
    
}
