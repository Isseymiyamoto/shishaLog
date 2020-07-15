//
//  Spot.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/29.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation

struct Spot {
    
    let spotID: String
    let location: String
    let shopID: String?
    var timestamp: Date!
    let user: User
    
    init(user: User, spotID: String, dictionary: [String: Any]) {
        self.user = user
        self.spotID = spotID
        
        self.location = dictionary["location"] as? String ?? ""
        self.shopID = dictionary["shopID"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
