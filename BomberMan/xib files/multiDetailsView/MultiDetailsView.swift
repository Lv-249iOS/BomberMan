//
//  MultiDetailsView.swift
//  BomberMan
//
//  Created by Alejandro Del Rio Albrechet on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class MultiDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var playersNames: [UILabel]!
    
    @IBOutlet weak var homeButton: UIButton!
    
    var onHomeButtTap: (()->())?
    
    @IBAction func onHomeTap(_ sender: UIButton) {
        onHomeButtTap?()
    }
    
    func setNames(names: [String]) {
        if playersNames.count >= names.count {
            var index: Int = 0
            for name in names {
                playersNames[index].text = name
                index += 1
            }
        }
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
        Bundle.main.loadNibNamed("MultiDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
