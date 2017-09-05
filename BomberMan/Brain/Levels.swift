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
        case two = "WWWWWWWWWWWWWWWW MWBW MBBBMWWWW             WW   BBBBB  WW WW  BBBBBBB    WW  BBBBB B    WW   BBBBB     WW  M BBB      WW     B M  0  WW     BBB     WW            MWWWWWWWWWWWWWWWW"
        case three = "WWWWWWWWWWWWWWWW 0           WW    BBWBB    WW   BBBWBBB   WW   BBBWBBB   WW    BBBBB    WW      B      WW     BBB     WW      B      WW  BBB WWWWW BWW          BWBWWWWWWWWWWWWWWWW"
        case four = "WWWWWWWWWWWWWWWW0  BBBBBBBB  WW WBW W W W W WW BB BBBB BBBBWWBW WBWBWBWBWBWWBBBBBB BB   BWWBWBWBWBWBWBW WWBBB B BBB  BBWWBWBWBW WBWBWBWW BBBBBBBBBBBBWW WBWBWBWBWBW WW  BBBBB BBB  WWWWWWWWWWWWWWWW"
        case five = "WWWWWWWWWWWWWWWWBB  B  BBB WBWW   BBW WBWBWBWWWWWBWBW  WBW WW  B  BB  BBBWWWB  BBB   W 0 WW             WW   BBB W BBB WW WWW    WWB  WWW BWBW  BWB  WW     B BB    WWWWWWWWWWWWWWWW"
        case six = "WWWWWWWWWWWWWWWWBB  B BB BBB WWBWBWBW WBWBWBWWBBBBBB  BBBBBWWBWBWBWBWBWBWBWW  B 0    BB  WW WBW W W W WBWW  B        B WW WBWBW WBW WBWWBBBB B B BBB WW W WBWBW W WBWWBB BBBB B BB WWWWWWWWWWWWWWWW"
        case seven = "WWWWWWWWWWWWWWWW   B B BB B 0WW WBW WBWBWBW WWB B   BBBB BBWWBW WBWBWBWBWBWWB B BBBBB  BBWWBWBWBWBW  WBWWW BB BB BBBB  WW WBW W WBW W WW BB  B   B BBWW WBWBW WBW W WW   B     BB  WWWWWWWWWWWWWWWW"
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


/*
 case one = "WWWWWWWWWW
             W  0     W
             W        W
             W        W
             W  B BBB W
             W  B B   W
             W  BBDBB W
             W    B B W
             WM BBBMB W
             WWWWWWWWWW"
 
 case two = "WWWWWWWWWWWWWWW
             W MWBW MBBBMWWW
             W             W
             W   BUBBB  WW W
             W  BBBBBBB    W
             W  BBDBBUB    W
             W   BBBBB     W
             W  M BBB      W
             W     B M  0  W
             W     BBB     W
             W            MW
             WWWWWWWWWWWWWWW"
 
 case three = "WWWWWWWWWWWWWWW
               W 0          MW
               W M  BBWBB    W
               W   BBBWBBB   W
               W   BBBWBDM   W
               W    BBBBB    W
               W      B      W
               W     BUB     W
               W      BM     W
               W  BUB WWWWW BW
               WM         BWBW
               WWWWWWWWWWWWWWW"

 case four = "WWWWWWWWWWWWWWW
              W0 MUBBBBBBB  W
              W WBW W W W W W
              W BB BBBB BBBBW
              WBW WBWBWBWBWBW
              WBBBBBB BB M BW
              WBWBWBWDWBWBW W
              WBBB B BBB  BBW
              WBWBWBW WBWBWBW
              W BBBBBBBBBBBBW
              W WBWBWBWBWBW W
              W MBBBBB UBBM W
              WWWWWWWWWWWWWWW"
 
 case five = "WWWWWWWWWWWWWWW
              WBB  B  BBB WBW
              W   UBW WMWBWBW
              WWWWBWBW  WBW W
              W  B MBB  BMBWW
              WB  BDB   W 0 W
              W            MW
              W   UBB W BMB W
              W WWWM   WWB  W
              WW BWMW  BWB  W
              W  M  B BB    W
              WWWWWWWWWWWWWWW"
 
 case six = "WWWWWWWWWWWWWWW
             WBB  B BB BBB W
             WBWMWBW WBWBWBW
             WBBBBBB  BBBBBW
             WBWBWMWBWUWBWBW
             W  B 0    BB  W
             W WBW W W W WBW
             W  M        B W
             W WBWBW WBW WBW
             WBBBB U B BMB W
             W W WBWMW W WBW
             WBB BBBB B BB W
             WWWWWWWWWWWWWWW"

 case seven = "WWWWWWWWWWWWWWW
               W   M B BB U 0W
               W WBW WBWBWBWMW
               WB B   BBBB BBW
               WBW WBWBWBWBWBW
               WB B MBBBB  BBW
               WBWBWBWBW  WBWW
               W BB BB BBBB  W
               W WBW W WBW W W
               W BB  B   B BBW
               W WBWBW WBW W W
               W   B     BB  W
               WWWWWWWWWWWWWWW"
 
 case eight = "WWWWWWWWWWWWWWWW    BB BB B 0WW BWB B B B B WWWWWW W  WW W WW BWBWBWBWB BWWWW  WW  WW WWWWW BWB BWBWBWBWWWWB B BWBWB B WW WWW WW   WWWWW BWB B B B B WW   W  WW     WWWWWWWWWWWWWWWW"
 
 case nine = "WWWWWWWWWWWWWWWW   BBBB B  WWWW WBWWWWWWWWW WW WBBW 0  BWW WW W         WWWW BW B      WWWW WWWWWWWBWWW WWB WBW WBWBWBWWWW   BBB BBBB WWBBB  WBW BB  WWWWBBWWW  B  WWWWWWWWWWWWWWWWW"

 
 
 
 
 */
