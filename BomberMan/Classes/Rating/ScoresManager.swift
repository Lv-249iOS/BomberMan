//
//  ScoresManager.swift
//  BomberMan
//
//  Created by Zhanna Moskaliuk on 8/29/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import Foundation

class ScoresManager {
    static let shared = ScoresManager()
    private init() {
        loadData()
    }
    
    var userScores: [UserScore] = []
    
    var filePath: String {
        
        // Manager lets you examine contents of a files and folders in our app , creates a directory to where we are saving it
        let manager = FileManager.default
        
        // This returns an array of urls from our documentDirectory and we take the first path
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        
        // Creates a new path component and creates a new file called "Data" which is where we will store our Data array.
        return (url!.appendingPathComponent("Data").path)
    }
    
    public func saveData(score: UserScore) {
        userScores.append(score)
        
        // NSKeyedArchiver is going to look in every records list class and look for encode function and is going to encode our data and save it to our file path. This does everything for encoding and decoding.
        // Archive root object saves our array of record (our data) to our filepath url
        NSKeyedArchiver.archiveRootObject(userScores, toFile: filePath)
    }
    
    public func loadData() {
        // if we can get back our data from our archives (load our data), get our data along our file path and cast it as an array of userscores
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [UserScore] {
            userScores = ourData
        }
    }
    
    // This function return sorted score's records
    public func topTen() -> [UserScore] {
        return userScores.sorted(by: { (current, next) -> Bool in
            return current.score > next.score
        })
    }
    
    // Delete our records from archive
    func removeFromArchive() {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        let objectPath = url?.appendingPathComponent("Data")
        userScores = []
        try? FileManager.default.removeItem(atPath: (objectPath?.path)!)
    }
}


