//
//  TilesFactory.swift
//  BomberMan
//
//  Created by AndreOsip on 9/26/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation
import UIKit

class TilesFactory {
    

    static func createTile(from char: Character, rect: CGRect)->UIView? {
    
        switch char {
        case "B":
            let view = BoxView(frame: rect)
            view.backgroundColor = UIColor.brown
            return view
        case "W":
            let wall = WallView(frame: rect)
            wall.backgroundColor = UIColor.gray
            return wall
            
        case "F": return addSubImageView(rect, image: #imageLiteral(resourceName: "fire"))
        case "X": return addSubImageView(rect, image: #imageLiteral(resourceName: "bomb"))
        case "D": return addSubImageView(rect, image: #imageLiteral(resourceName: "door"))
            
        default: break
        
        }
    return nil
    }

}

func addSubImageView(_ rect: CGRect, image: UIImage)->UIView {
    let imageSub = UIImageView(frame: rect)
    imageSub.image = image
    return imageSub
}
