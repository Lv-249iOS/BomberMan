//
//  MoveToNextLevel.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class MoveToNextLevelView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var moveOnButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Closures for repeat and continue actions
    var onRepeatButtTap: (()->())?
    var onMoveOnButtTap: (()->())?

    // Block with button actions
    
    @IBAction func onRepeatTap(_ sender: UIButton) {
        onRepeatButtTap?()
    }
    
    @IBAction func onContinueTap(_ sender: UIButton) {
        onMoveOnButtTap?()
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
    
    // This is custom init with view created in xib file
    private func commonInit() {
        Bundle.main.loadNibNamed("MoveToNextLevelView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
