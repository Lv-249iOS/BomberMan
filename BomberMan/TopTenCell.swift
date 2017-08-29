//
//  TopTenCell.swift
//  BomberMan
//
//  Created by Zhanna Moskaliuk on 8/29/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class TopTenCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var raitingScore: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    public func configure(with score: UserScore){
        userName.text = score.username
        raitingScore.text = "\(score.score)"
        dateLabel.text = score.date.timeSince()
    }
}
