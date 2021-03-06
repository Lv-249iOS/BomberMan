//
//  UserScore.swift
//  BomberMan
//
//  Created by Zhanna Moskaliuk on 8/29/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

class UserScore: NSObject, NSCoding {
    
    // Set names for my keys
    struct Key {
        static let id = "id"
        static let username = "username"
        static let score = "score"
        static let date = "date"
    }
    
    var id: String = ""
    var username: String = ""
    var score: Int = 0
    var date: Date = Date()
    
    override init() {}
    
    // My initialiser
    init(username: String, score: Int) {
        self.id = UUID().uuidString // generate random unique id
        self.username = username
        self.score = score
        self.date = Date()
    }
    
    // Decode objects
    required init?(coder aDecoder: NSCoder) {
        
        // Retrives our saved objects and casts it as...
        if let id = aDecoder.decodeObject(forKey: Key.id) as? String {
            self.id = id
        }
        if let username = aDecoder.decodeObject(forKey: Key.username) as? String {
            self.username = username
        }
        self.score = aDecoder.decodeInteger(forKey: Key.score)
        if let date = aDecoder.decodeObject(forKey: Key.date) as? Date {
            self.date = date
        }
    }
    
    // Encode (save) our objects
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Key.id)
        aCoder.encode(username, forKey: Key.username)
        aCoder.encode(score, forKey: Key.score)
        aCoder.encode(date, forKey: Key.date)
    }
}
