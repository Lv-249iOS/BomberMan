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
    @IBOutlet weak var bombButton: UIButton!
    
    var onBombTap: (()->())?
    var onArrowTap: ((Direction)->())?
    
    @IBAction func bombTaped(_ sender: UIButton) {
        onBombTap?()
    }
    
    @IBAction func arrowTap(_ sender: UIButton) {
        if let arrowTag = Direction(rawValue: sender.tag) {
            onArrowTap?(arrowTag)
        }
    }
    
    func setButtonState(isEnabled: Bool) {
        bombButton.isEnabled = isEnabled
        for but in directionButton {
            but.isEnabled = isEnabled
        }
    }
    
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
        bombButton.imageView?.contentMode = .scaleAspectFit
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
