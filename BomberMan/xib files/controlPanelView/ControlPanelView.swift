//
//  ControlPanelView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/2/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class ControlPanelView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var directionButton: [UIButton]!
    @IBOutlet weak var bombButton: UIButton?
    
    var onBombTap: (()->())?
    var onArrowTouchUp: (()->())?
    var onArrowTouchDown: ((Direction)->())?
    
    @IBAction func bombTaped(_ sender: UIButton) {
        onBombTap?()
    }
    
    @IBAction func arrowTouchUp(_ sender: UIButton) {
        onArrowTouchUp?()
    }
    
    @IBAction func arrowTouchDown(_ sender: UIButton) {
        if let arrowTag = Direction(rawValue: sender.tag) {
            onArrowTouchDown?(arrowTag)
        }
    }
    
    func setButtonState(isEnabled: Bool) {
        bombButton?.isEnabled = isEnabled
        for but in directionButton {
            but.isEnabled = isEnabled
        }
    }
    
    func removeBombButton() {
        bombButton?.removeFromSuperview()
    }
    
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
        Bundle.main.loadNibNamed("ControlPanelView", owner: self, options: nil)
        bombButton?.imageView?.contentMode = .scaleAspectFit
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
