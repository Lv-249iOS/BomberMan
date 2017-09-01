//
//  MoveToNextLevel.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class MoveToNextLevel: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var moveOnButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var onRepeatButtTap: (()->())?
    var onMoveOnButtTap: (()->())?

    @IBAction func onRepeatTap(_ sender: UIButton) {
        onRepeatButtTap?()
    }
    
    @IBAction func onContinueTap(_ sender: UIButton) {
        onMoveOnButtTap?()
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
        Bundle.main.loadNibNamed("MoveToNextLevel", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
