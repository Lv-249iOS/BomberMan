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
        
        map =
        "WWWWWWWWWW  P    WW       WW       WW       WW       WW B B B WW       WWWWWWWWWW"
        
        var ii = 0
        var jj = 0
        let sideTilesCount = sqrt(Double(map.characters.count))
        
        for i in map.characters {
            
            if i == "W" {
                
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let wall = WallView(frame: rect)
                wall.backgroundColor = UIColor.darkGray
                mapScroll.addSubview(wall)
                
            } else if i == "B" {
                
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                let box = BoxView(frame: rect)
                box.backgroundColor = UIColor.brown
                mapScroll.addSubview(box)
                
            } else if i == "P" {
                
                let rect = CGRect(x: ii, y: jj, width: 50, height: 50)
                orc = UIImageView(frame: rect)
                orc.image = UIImage(named: "orc1")
                mapScroll.addSubview(orc)
                
            }
            
            if ii / 50 == Int(sideTilesCount-1) {
                jj += 50
                ii = 0
            } else {
                ii += 50
            }
        }
        
        mapScroll.contentSize.width = 450
        mapScroll.contentSize.height = 450
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
