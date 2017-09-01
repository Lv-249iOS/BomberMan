//
//  Levels.swift
//  BomberMan
//
//  Created by Zhanna Moskaliuk on 9/1/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

class Levels {
    
    enum Level: String {
        case one = "WWWWWWWWWWWWWWWWP  BBBBBBBB  WW WBW W W W W WW BB BBBB BBBBWWBW WBWBWBWBWBWWBBBBBB BB   BWWBWBWBWBWBWBW WWBBB B BBB  BBWWBWBWBW WBWBWBWW BBBBBBBBBBBBWW WBWBWBWBWBW WW  BBBBB BBB  WWWWWWWWWWWWWWWW"
        case two = "WWWWWWWWWWWWWWWWBB  B BB BBB WWBWBWBW WBWBWBWWBBBBBB  BBBBBWWBWBWBWBWBWBWBWW  B P    BB  W W WBW W W W WBWW  B        B WW WBWBW WBW WBWWBBBB B B BBB WW W WBWBW W WBWWBB BBBB B BB W"
        case three = "WWWWWWWWWWWWWWWW   B B BB B PWW WBW WBWBWBW WWB B   BBBB BBWWBW WBWBWBWBWBWWB B BBBBB  BBWWBWBWBWBW  WBWWW BB BB BBBB  WW WBW W WBW W WW BB  B   B BBWW WBWBW WBW W WW   B     BB  W"
        case four = "WWWWWWWWWWWWWWWW    BB BB B PWW BWB B B B B WWWWWW W  WW W WW BWBWBWBWB BWWWW  WW  WW WWWWW BWB BWBWBWBWWWWB B BWBWB B WW WWW WW   WWWWW BWB B B B B WW   W  WW     WWWWWWWWWWWWWWWW"
        case five = "WWWWWWWWWWWWWWWW   BBBB B  WWWW WBWWWWWWWWW WW WBBW P  BWW WW W         WWWW BW B      WWWW WWWWWWWBWWW WWB WBW WBWBWBWWWW   BBB BBBB WWBBB  WBW BB  WWWWBBWWW  B  WWWWWWWWWWWWWWWWW"
    }
    
    /*      */
    
    
    
    let levels = [
        Level.one,
        Level.two
    ]
    
    func level(with index: Int) -> String? {
        if index < levels.count {
            return levels[index].rawValue
        }
        return nil
    }
}
