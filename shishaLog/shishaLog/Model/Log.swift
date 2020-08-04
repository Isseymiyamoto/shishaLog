//
//  Log.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/16.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation
import Firebase

struct Log {
    
    let logID: String
    let location: String
    var shopID: String?
    let mix: String
    let feeling: String
    var timestamp: Date!
    var user: User
    var likes: Int
    var didLike = false
    
    init(user: User, logID: String, dictionary: [String: Any]) {
        self.user = user
        self.logID = logID
        
        self.location = dictionary["location"] as? String ?? ""
        self.mix = dictionary["mix"] as? String ?? ""
        self.feeling = dictionary["feeling"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let shopID = dictionary["shopID"] as? String{
            self.shopID = shopID
        }
    }
    
    
}
