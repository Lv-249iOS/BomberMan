//
//  LoseMultiplayerView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/21/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class LoseMultiplayerView: UIView {
    
    @IBOutlet var contentView: UIView!

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
        Bundle.main.loadNibNamed("LoseMultiplayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
