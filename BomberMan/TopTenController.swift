//
//  TopTenController.swift
//  BomberMan
//
//  Created by Zhanna Moskaliuk on 8/29/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class TopTenController: UITableViewController {
    
    var scores: [UserScore] = ScoresManager.shared.topTen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topTenCell", for: indexPath) as? TopTenCell else {
            return UITableViewCell()
        }
        
        let score = scores[indexPath.row]
        cell.configure(with: score)
        
        return cell
    }

    
    public func clearScores() {
        scores.removeAll()
        tableView.reloadData()
    }
}
