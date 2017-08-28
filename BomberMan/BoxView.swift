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
        let path = UIBezierPath(rect: rect)
        
        path.move(to: CGPoint(x: rect.width / 5, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 5, y: rect.height))
        
        path.move(to: CGPoint(x: rect.width * 4 / 5, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 4 / 5, y: rect.height))
        
        path.move(to: CGPoint(x: rect.width / 5, y: rect.height / 5))
        path.addLine(to: CGPoint(x: rect.width * 4 / 5, y: rect.height / 5))
        
        path.move(to: CGPoint(x: rect.width / 5, y: rect.height * 4 / 5))
        path.addLine(to: CGPoint(x: rect.width * 4 / 5, y: rect.height * 4 / 5))
        
        path.move(to: CGPoint(x: rect.width * 2 / 5, y: rect.height / 5))
        path.addLine(to: CGPoint(x: rect.width * 2 / 5, y: rect.height * 4 / 5))
        
        path.move(to: CGPoint(x: rect.width * 3 / 5, y: rect.height / 5))
        path.addLine(to: CGPoint(x: rect.width * 3 / 5, y: rect.height * 4 / 5))
        
        let radius = (rect.height / 5) / 4
        let circle = UIBezierPath(arcCenter: CGPoint(x: (rect.width / 5) / 2, y: (rect.height / 5) / 2), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let circle2 = UIBezierPath(arcCenter: CGPoint(x: (rect.width * 4 / 5) + (rect.width / 5) / 2, y: (rect.height / 5) / 2), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let circle3 = UIBezierPath(arcCenter: CGPoint(x: (rect.width / 5) / 2, y: (rect.height * 4 / 5) +  (rect.height / 5) / 2), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let circle4 = UIBezierPath(arcCenter: CGPoint(x: (rect.width * 4 / 5) + (rect.width / 5) / 2, y: (rect.height * 4 / 5) + (rect.height / 5) / 2), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        UIColor.darkGray.setFill()
        
        path.lineWidth = 3
        circle.lineWidth = 3
        circle2.lineWidth = 3
        circle3.lineWidth = 3
        circle4.lineWidth = 3
        
        path.stroke()
        circle2.fill()
        circle.fill()
        circle3.fill()
        circle4.fill()
        circle.stroke()
        circle2.stroke()
        circle3.stroke()
        circle4.stroke()
    }
    
    
}
