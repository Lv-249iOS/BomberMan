//
//  Upgrade.swift
//  BomberMan
//
//  Created by Yaroslav Luchyt on 8/26/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

struct Upgrade {
    var position: Int
    var type: UpgradeType = .anotherBomb
}

struct Bomb {
    var owner: Player
    var power: Int
    var timer: Timer?
    var position: Int
}

struct Player {
    var name = ""
    var identifier = 0
    var minesCount = 1
    var explosionPower = 1
    var position = 0
    var plantedMines = 0
    var isAlive = true
}

struct Mob {
    var identifier = 0
    var position: Int
    var direction: Direction
}

struct Explosion {
    var top = 0
    var bottom = 0
    var left = 0
    var right = 0
}

enum UpgradeType: Int {
    case anotherBomb
    case strongerBomb
}

enum ItemsWithIcon: Int {
    case door
    case anotherBomb
    case strongerBomb
}

enum Direction: Int {
    case top = 1
    case bottom = 4
    case left  = 2
    case right = 3
}

enum ScoreBoosts: Int {
    case death = -1000
    case mobKill = 200
    case upgrade = 100
    case door = 500
    case timeScoreBooster = 5
}
