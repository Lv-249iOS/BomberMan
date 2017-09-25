//
//  GameMapController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 8/28/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class GameMapController: UIViewController {
    
    @IBOutlet weak var mapScroll: UIScrollView!
    
    var onMapDoubleTap: (()->())?
    var doubleTapGesture: UITapGestureRecognizer?
    let brain = Brain.shared
    var singleGame = true
    var players: [UIImageView] = []
    var mobs: [UIImageView] = []
    var clickСount: [Int] = [0,0,0,0,0,0,0,0]
    var animationCount: [Int] = [0,0,0,0,0,0,0,0]
    var chosenSkinIndex = SettingsModel.shared.currentCharacterImage
    var chosenSkin: Int!
    
    private var map: String!
    private var sceneWidth: Int!
    private var firstTime = true
    
    func respondToDoubleTapGesture(_ gesture: UIGestureRecognizer) {
        onMapDoubleTap?()
    }
    
    func initGestureRecognizer() {
        // add some checking
        doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture?.numberOfTapsRequired = 2
        doubleTapGesture?.addTarget(self, action: #selector(respondToDoubleTapGesture))
        mapScroll.addGestureRecognizer(doubleTapGesture!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenSkin = chosenSkinIndex * (singleGame ? 1 : 0)
    
        // MARK: Uses everytime
        initGestureRecognizer()
        
        if singleGame {
            brain.setDevices(names: [UIDevice.current.name])
            brain.initializeGame(with: 0, completelyNew: true)
        } else {
            brain.initializeMultiplayerGame()
        }
        
        updateContentSize()
        
        brain.showFire = { [weak self] explosion, center in
            self?.explode(ranges: explosion, center: center)
        }
        brain.move = { [weak self] direction, player in
            self?.move(in: direction, player: player)
        }
        brain.plantBomb = { [weak self] player in
            self?.addBomb(player: player)
        }
        brain.redrawScene = { [weak self] in
            self?.drawMap()
        }
        brain.killHero = { [weak self] player, inPlace in
            self?.killHero(player: player, inPlace: inPlace)
        }
        brain.moveMob = { [weak self] direction, mob in
            self?.moveMob(in: direction, mob: mob)
        }
        brain.killMob = { [weak self] mob, inPlace in
            self?.killMob(mob: mob, inPlace: inPlace)
        }
        brain.boxExplode = { [weak self] position in
            self?.boxExplosion(pos: position)
        }
    }
    
    func addSubImageView(_ rect: CGRect, image: UIImage) {
        let imageSub = UIImageView(frame: rect)
        imageSub.image = image
        mapScroll.addSubview(imageSub)
    }
    
    func addSubBoxView(x: Int, y: Int) {
        let rect = CGRect(x: x, y: y, width: 50, height: 50)
        let box = BoxView(frame: rect)
        box.backgroundColor = UIColor.brown
        mapScroll.addSubview(box)
    }
    
    func addBomb(player: Int) {
        addSubImageView(CGRect(x: players[player].frame.origin.x, y: players[player].frame.origin.y, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
        
        mapScroll.willRemoveSubview(players[player])
        mapScroll.addSubview(players[player])
    }
    
    func updateContentSize() {
        sceneWidth = brain.width
        mapScroll.contentSize = CGSize(width: 50 * sceneWidth, height: 50 * (brain.tiles.count / sceneWidth))
        firstTime = true
        mobs.removeAll()
        players.removeAll()
        drawMap()
        
        for i in 0 ..< brain.players.count {
            if brain.players[i].name == UIDevice.current.name {
            
                let frame = CGRect(x: (players[i].frame.origin.x) - 150, y: (players[i].frame.origin.y) - 150, width: 350, height: 350)
            
                mapScroll.scrollRectToVisible(frame, animated: true)
                break
            }
        }
        
    }
    
    func drawMap() {
        
        for subview in mapScroll.subviews {
            if let subImageView = subview as? UIImageView {
                if !players.contains(subImageView), !mobs.contains(subImageView), subImageView.tag != 66 {
                    subview.removeFromSuperview()
                }
            } else {
                subview.removeFromSuperview()
            }
            
        }
        
        var i = 0
        var j = 0
        var upgradeCounter = 0
        
        for tile in brain.tiles {
            for tileElement in tile {
                switch tileElement {
                case "W":
                    let rect = CGRect(x: i, y: j, width: 50, height: 50)
                    let wall = WallView(frame: rect)
                    wall.backgroundColor = UIColor.gray
                    mapScroll.addSubview(wall)
                case "B":
                    addSubBoxView(x: i, y: j)
                case "P":
                    if firstTime {
                        let rect = CGRect(x: i, y: j, width: 50, height: 50)
                        let player = UIImageView(frame: rect)
                        player.image = UIImage(named: "bom\(players.count + chosenSkin)") ?? #imageLiteral(resourceName: "noImage")
                        players.append(player)
                        if !players.isEmpty {
                            mapScroll.addSubview(players.last!)
                        }
                    }
                case "F":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "fire"))
                    
                case "X":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
                    
                case "Q":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "bomb"))
                    
                    let rect = CGRect(x: i, y: j, width: 50, height: 50)
                    let player = UIImageView(frame: rect)
                    player.image = UIImage(named: "hero")
                    players.last!.removeFromSuperview()
                    players.removeLast()
                    players.append(player)
                    mapScroll.addSubview(players.last!)
                case "M":
                    if firstTime {
                        let rect = CGRect(x: i, y: j, width: 50, height: 50)
                        let mob = UIImageView(frame: rect)
                        mob.image = #imageLiteral(resourceName: "balloon1")
                        mobs.append(mob)
                        if !mobs.isEmpty {
                            mapScroll.addSubview(mobs.last!)
                        }
                    }
                case "U":
                    let rect = CGRect(x: i, y: j, width: 50, height: 50)
                    let upgrades = brain.upgrades
                    if !upgrades.isEmpty, upgradeCounter < upgrades.count {
                    switch upgrades[upgradeCounter].type {
                    case .anotherBomb:
                        addSubImageView(rect, image: #imageLiteral(resourceName: "bombupgrade"))
                    case .strongerBomb:
                        addSubImageView(rect, image: #imageLiteral(resourceName: "powerupgrade"))
                    }
                    upgradeCounter += 1
                    }
                case "D":
                    addSubImageView(CGRect(x: i, y: j, width: 50, height: 50), image: #imageLiteral(resourceName: "door"))
                default:
                    break
                }
                
            }
            if i / 50 == sceneWidth - 1 {
                j += 50
                i = 0
            } else {
                i += 50
            }
            
        }
        
        firstTime = false
        
    }
    
}
