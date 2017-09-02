//
//  WallView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/25/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

@IBDesignable
class WallView: UIView {
    
    let wallPath = UIBezierPath()
    var wallRect: CGRect!
    
    override func draw(_ rect: CGRect) {
        wallRect = rect
        
        addBlocksLevels()
        addBlocksOnTopLvl()
        addBlocksOnSecondLvl()
        addBlocksOnMidLvl()
        addBlocksOnForthLvl()
        addBottomBlocksLvl()
        
        UIColor.black.setStroke()
        wallPath.lineWidth = 5
        wallPath.stroke()
    }
    
    // Adds bottom level of brick wall
    func addBottomBlocksLvl() {
        addLine(from: CGPoint(x: wallRect.width, y: wallRect.height * 4 / 5),
                to: CGPoint(x: wallRect.width, y: wallRect.height))
        
        addLine(from: CGPoint(x: wallRect.width * 3 / 5, y: wallRect.height * 4 / 5),
                to: CGPoint(x: wallRect.width * 3 / 5, y: wallRect.height))
        
        addLine(from: CGPoint(x: 0, y: wallRect.height * 4 / 5),
                to: CGPoint(x: 0, y: wallRect.height))
    }
    
    // Adds level upper bottom of brick wall
    func addBlocksOnForthLvl() {
        addLine(from: CGPoint(x: wallRect.width * 4 / 5, y: wallRect.height * 3 / 5),
                to: CGPoint(x: wallRect.width * 4 / 5, y: wallRect.height * 4 / 5))
        
        addLine(from: CGPoint(x: wallRect.width / 5, y: wallRect.height * 3 / 5),
                to: CGPoint(x: wallRect.width / 5, y: wallRect.height * 4 / 5))
    }
    
    // Adds middle layer of brick wall
    func addBlocksOnMidLvl() {
        addLine(from: CGPoint(x: 0, y: wallRect.height * 2 / 5),
                to:  CGPoint(x: 0, y: wallRect.height * 3 / 5))
        
        addLine(from: CGPoint(x: wallRect.width * 2 / 5, y: wallRect.height * 2 / 5),
                to: CGPoint(x: wallRect.width * 2 / 5, y: wallRect.height * 3 / 5))
        
        addLine(from: CGPoint(x: wallRect.width, y: wallRect.height * 2 / 5),
                to: CGPoint(x: wallRect.width, y: wallRect.height * 3 / 5))
    }
    
    // Adds level under top level of brick wall
    func addBlocksOnSecondLvl() {
        addLine(from: CGPoint(x: wallRect.width / 5, y: wallRect.height / 5),
                to: CGPoint(x: wallRect.width / 5, y: wallRect.height * 2 / 5))
        
        addLine(from: CGPoint(x: wallRect.width * 3 / 5, y: wallRect.height / 5),
                to: CGPoint(x: wallRect.width * 3 / 5, y: wallRect.height * 2 / 5))
    }
    
    // Adds top level of brick wall
    func addBlocksOnTopLvl() {
        addLine(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: wallRect.height / 5))
        addLine(from: CGPoint(x: wallRect.width * 2 / 5, y: 0),
                to: CGPoint(x: wallRect.width * 2 / 5, y: wallRect.height / 5))
        
        addLine(from: CGPoint(x: wallRect.width, y: 0),
                to: CGPoint(x: wallRect.width, y: wallRect.height / 5))
    }
    
    // Adds horizontal lines for every level of bricks
    func addBlocksLevels() {
        for i in 0 ..< 6 {
            addLine(from: CGPoint(x: 0, y: wallRect.height * CGFloat(i) / 5),
                    to:  CGPoint(x: wallRect.width, y: wallRect.height * CGFloat(i) / 5))
        }
    }
    
    // Adds line between two points
    func addLine(from startPoint: CGPoint, to endPoint: CGPoint) {
        wallPath.move(to: startPoint)
        wallPath.addLine(to: endPoint)
    }
}
