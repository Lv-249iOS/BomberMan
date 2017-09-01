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
    @IBOutlet var playersLabel: [UILabel]!
    @IBOutlet weak var p2name: UILabel!
    @IBOutlet weak var p1name: UILabel!
    @IBOutlet weak var p4name: UILabel!
    @IBOutlet weak var p3name: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    
    var onHomeButtTap: (()->())?
    
    @IBAction func onHomeTap(_ sender: UIButton) {
        onHomeButtTap?()
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
        Bundle.main.loadNibNamed("MultiDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
