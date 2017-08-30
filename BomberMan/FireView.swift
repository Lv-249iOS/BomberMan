//
//  FireView.swift
//  BomberMan
//
//  Created by Alejandro Del Rio Albrechet on 8/30/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class FireView: UIView {
    
    func createFire() {
        let fireEmitter = CAEmitterLayer()
        fireEmitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        fireEmitter.emitterSize = CGSize(width: bounds.width / 2, height: bounds.height / 2)
        fireEmitter.renderMode = kCAEmitterLayerAdditive
        fireEmitter.emitterShape = kCAEmitterLayerLine
        fireEmitter.emitterCells = [createFireCell()]
        
        layer.addSublayer(fireEmitter)
    }
    
    func createFireCell() -> CAEmitterCell {
        let fire = CAEmitterCell()
        
        fire.alphaSpeed = -0.3
        fire.birthRate = 300
        fire.lifetime = 1.0
        fire.lifetimeRange = 0.5
        fire.color = UIColor(colorLiteralRed: 0.8, green: 0.4, blue: 0.2, alpha: 0.6).cgColor
        fire.contents = UIImage(named: "fire")?.cgImage
        fire.emissionLongitude = CGFloat(CGFloat.pi)
        fire.velocity = 20
        fire.velocityRange = 5
        fire.emissionRange = 0.5
        fire.yAcceleration = -100
        fire.scaleSpeed = 0.3

        return fire
    }
}
