//
//  PhoneView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/4/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class PhoneView: UIView, CAAnimationDelegate {

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var phoneIcon: UIImageView!
    
    // UIViews can be created two ways: interface builder or  directly in code
    // They have a initializer for each of these creation methods
    // and we need to override both of them with our own custom initializer.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PhoneView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // Animation block for phone view spinning
    
    func runSpinAnimationOn(duration: Double = 2, rotation: Double = 1, repeats: Float = .infinity) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.delegate = self
        
        animation.toValue = NSNumber(value: Double.pi * 2.0 * rotation)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeats
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        phoneIcon.layer.add(animation, forKey: "rotationAnimation")
    }
    
    func stopSpinAnimation() {
        phoneIcon.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
