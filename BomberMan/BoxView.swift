//
//  BoxView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/25/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

@IBDesignable
class BoxView: UIView {
    
    override func draw(_ rect: CGRect) {
        drawCircles(with: generateCirclePoints(in: rect), radius: getRadius(in: rect))
        drawLines(with: generateLinesPoints(in: rect), in: rect)
    }
    
    /// Draws all boards inside box
    func drawLines(with lines: [(p1: CGPoint, p2: CGPoint)], in rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        
        for line in lines {
            path.move(to: line.p1)
            path.addLine(to: line.p2)
        }
        
        path.lineWidth = 3
        path.stroke()
    }
    
    /// Draw small circles similar to irons
    func drawCircles(with points: [CGPoint], radius: CGFloat) {
        for point in points {
            let path = circlePath(with: point, radius: radius)
            
            path.fill()
            path.stroke()
        }
    }
    
    /// Returns const distance between circle and rect bounds
    func getDistance(in rect: CGRect) -> (width: CGFloat, height: CGFloat) {
        return (width: (rect.width / 5) / 2, height: (rect.height / 5) / 2)
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
    
    /// Generate dots pair
    func generateLinesPoints(in rect: CGRect) -> [(p1: CGPoint, p2: CGPoint)] {
        let const = (width: rect.width / 5, height: rect.height / 5)
        
        let big1 = (p1: CGPoint(x: const.width, y: 0),
                    p2: CGPoint(x: const.width, y: rect.height))
        
        let big2 = (p1: CGPoint(x: 4 * const.width, y: 0),
                    p2: CGPoint(x: 4 * const.width, y: rect.height))
        
        let smallH1 = (p1: CGPoint(x: const.width, y: const.height),
                       p2: CGPoint(x: 4 * const.width, y: const.height))
        
        let smallH2 = (p1: CGPoint(x: const.width, y: 4 * const.height),
                       p2: CGPoint(x: 4 * const.width, y: 4 * const.height))
        
        let smallV1 = (p1:  CGPoint(x: 2 * const.width, y: const.height),
                       p2: CGPoint(x: 2 * const.width, y: 4 * const.height))
        
        let smallV2 = (p1: CGPoint(x: 3 * const.width, y: const.height),
                       p2: CGPoint(x: 3 * const.width, y: 4 * const.height))
        
        
        return [big1, big2, smallH1, smallH2, smallV1, smallV2]
    }
    
    /// Creates 4 points in the angles in the rect
    func generateCirclePoints(in rect: CGRect) -> [CGPoint] {
        let distance = getDistance(in: rect)
        
        let topLeftPoint = CGPoint(x: rect.minX + distance.width, y: rect.minY + distance.height)
        let topRightPoint = CGPoint(x: rect.minX + rect.width - distance.width, y: rect.minY + distance.height)
        let bottomLeftPoint = CGPoint(x: rect.minX + distance.width, y: rect.minY + rect.height - distance.height)
        let bottomRightPoint = CGPoint(x: rect.minX + rect.width - distance.width, y: rect.minY + rect.height - distance.height)
        
        return [topLeftPoint, topRightPoint, bottomLeftPoint, bottomRightPoint]
    }
}
