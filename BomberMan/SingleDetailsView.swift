//
//  SingleDetailsView.swift
//  BomberMan
//
//  Created by Alejandro Del Rio Albrechet on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class SingleDetailsView: UIView {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreNameLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textInfoStackView: UIStackView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var scoreStackView: UIStackView!

    var onHomeButtTap: (()->())?
    var onPauseButtTap: (()->())?
    
    @IBAction func onHomeTap(_ sender: UIButton) {
        onHomeButtTap?()
    }

    @IBAction func onPauseTap(_ sender: UIButton) {
        onPauseButtTap?()
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
        Bundle.main.loadNibNamed("SingleDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
