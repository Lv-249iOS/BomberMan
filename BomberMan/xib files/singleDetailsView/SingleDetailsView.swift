//
//  SingleDetailsView.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class SingleDetailsView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    // Closures for back to home and pause actions
    
    var onHomeButtTap: (()->())?
    var onPauseButtTap: (()->())?
    
    @IBAction func onHomeTap(_ sender: UIButton) {
        onHomeButtTap?()
    }

    @IBAction func onPauseTap(_ sender: UIButton) {
        onPauseButtTap?()
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
        Bundle.main.loadNibNamed("SingleDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
