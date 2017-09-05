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
        tableView.rowHeight = 80 // approximate hieght of cells
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
        
        // Set medals for first three places
        switch indexPath.row {
        case 0: cell.cellImage?.image = #imageLiteral(resourceName: "gold-medal")
        case 1: cell.cellImage?.image = #imageLiteral(resourceName: "silver-medal")
        case 2: cell.cellImage?.image = #imageLiteral(resourceName: "bronze-medal")
        default: break
        }
        
        return cell
    }
    
    // Clearing all records from table view
    public func clearScores() {
        scores.removeAll()
        tableView.reloadData()
    }
}
