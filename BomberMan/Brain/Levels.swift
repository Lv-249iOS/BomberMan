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
        case one = "WWWWWWWWWWW  0     WW        WW        WW  B BBB WW  B B   WW  BBBBB WW    B B WWM BBBMB WWWWWWWWWWW"
        case two = "WWWWWWWWWWWWWWWW  WBW  BBB WWWW             WW   BBBBB  WW WW  BBBBBBB    WW  B BBB B    WW   BBBBB     WW    BBB      WW     B    0  WW     BBB     WW             WWWWWWWWWWWWWWWW"
        case three = "WWWWWWWWWWWWWWWW 0           WW    BBWBB    WW   BBBWBBB   WW   BBBWBBB   WW    BBBBB    WW      B      WW     BBB     WW      B      WW  BBB WWWWW BWW          BWBWWWWWWWWWWWWWWWW"
        case four = "WWWWWWWWWWWWWWWW0  BBBBBBBB  WW WBW W W W W WW BB BBBB BBBBWWBW WBWBWBWBWBWWBBBBBB BB   BWWBWBWBWBWBWBW WWBBB B BBB  BBWWBWBWBW WBWBWBWW BBBBBBBBBBBBWW WBWBWBWBWBW WW  BBBBB BBB  WWWWWWWWWWWWWWWW"
        case five = "WWWWWWWWWWWWWWWWBB  B  BBB WBWW   BBW WBWBWBWWWWWBWBW  WBW WW  B  BB  BBBWWWB  BBB   W 0 WW             WW   BBB W BBB WW WWW    WWB  WWW BWBW  BWB  WW     B BB    WWWWWWWWWWWWWWWW"
        case six = "WWWWWWWWWWWWWWWWBB  B BB BBB WWBWBWBW WBWBWBWWBBBBBB  BBBBBWWBWBWBWBWBWBWBWW  B 0    BB  W W WBW W W W WBWW  B        B WW WBWBW WBW WBWWBBBB B B BBB WW W WBWBW W WBWWBB BBBB B BB W"
        case seven = "WWWWWWWWWWWWWWWW   B B BB B 0WW WBW WBWBWBW WWB B   BBBB BBWWBW WBWBWBWBWBWWB B BBBBB  BBWWBWBWBWBW  WBWWW BB BB BBBB  WW WBW W WBW W WW BB  B   B BBWW WBWBW WBW W WW   B     BB  W"
        case eight = "WWWWWWWWWWWWWWWW    BB BB B 0WW BWB B B B B WWWWWW W  WW W WW BWBWBWBWB BWWWW  WW  WW WWWWW BWB BWBWBWBWWWWB B BWBWB B WW WWW WW   WWWWW BWB B B B B WW   W  WW     WWWWWWWWWWWWWWWW"
        case nine = "WWWWWWWWWWWWWWWW   BBBB B  WWWW WBWWWWWWWWW WW WBBW 0  BWW WW W         WWWW BW B      WWWW WWWWWWWBWWW WWB WBW WBWBWBWWWW   BBB BBBB WWBBB  WBW BB  WWWWBBWWW  B  WWWWWWWWWWWWWWWWW"
    }
    
    let levels = [
        Level.one,
        Level.two,
        Level.three,
        Level.four,
        Level.five,
        Level.six,
        Level.seven,
        Level.eight,
        Level.nine
    ]
    
    func level(with index: Int) -> String {
        if index < levels.count {
            return levels[index].rawValue
        }
        
        return levels[0].rawValue
    }
}
