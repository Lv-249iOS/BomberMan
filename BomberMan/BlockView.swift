//
//  BlockView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/29/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

@IBDesignable
class BlockView: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 3.0
    
    @IBInspectable var ironsColor: UIColor = UIColor.darkGray
    @IBInspectable var strokeColor: UIColor = UIColor.black
    
    @IBInspectable var outsideRectColor: UIColor = UIColor.darkGray
    @IBInspectable var insideRectColor: UIColor = UIColor.lightGray
    
    override func draw(_ rect: CGRect) {
        let newRect = insideRect(in: rect)
        
        strokeColor.setStroke()
        drawRects(with: [rect, newRect])
        drawCircles(woth: createCirclePoints(in: newRect), radius: getRadius(in: newRect))
    }
    
    /// Draws 2 rects
    func drawRects(with rects: [CGRect]) {
        for rect in rects {
            let path = UIBezierPath(rect: rect)
            
            path.lineWidth = lineWidth
            rect == rects[0] ? outsideRectColor.setFill() : insideRectColor.setFill()
            
            path.fill()
            path.stroke()
        }
    }
    
    /// Recurn new rect with 90% size
    func insideRect(in rect: CGRect) -> CGRect {
        return CGRect(x:rect.minX + rect.width / 100 * 5,
                      y: rect.height / 100 * 5,
                      width: rect.width / 100 * 90,
                      height: rect.height / 100 * 90)
    }
    
    /// Draw small circles similar to irons
    func drawCircles(woth points: [CGPoint], radius: CGFloat) {
        ironsColor.setFill()
        
        for point in points {
            let path = circlePath(with: point, radius: radius)
            path.lineWidth = lineWidth / 2
            
            path.fill()
            path.stroke()
        }
    }
    
    /// Creates 4 points in the angles in the rect
    func createCirclePoints(in rect: CGRect) -> [CGPoint] {
        let distance = getDistance(in: rect)
        
        let topLeftPoint = CGPoint(x: rect.minX + distance.width, y: rect.minY + distance.height)
        let topRightPoint = CGPoint(x: rect.minX + rect.width - distance.width, y: rect.minY + distance.height)
        let bottomLeftPoint = CGPoint(x: rect.minX + distance.width, y: rect.minY + rect.height - distance.height)
        let bottomRightPoint = CGPoint(x: rect.minX + rect.width - distance.width, y: rect.minY + rect.height - distance.height)
        
        return [topLeftPoint, topRightPoint, bottomLeftPoint, bottomRightPoint]
    }
    
    /// Returns const distance between circle and rect bounds
    func getDistance(in rect: CGRect) -> (width: CGFloat, height: CGFloat) {
        return (width: (rect.width / 5) / 1.5, height: (rect.height / 5) / 1.5)
    }
    
    /// Generates radius for small circles inside rect
    func getRadius(in rect: CGRect) -> CGFloat {
        return (rect.height / 5) / 8
    }
    
    /// Returns circle path
    func circlePath(with center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        
        return path
    }
    
}
