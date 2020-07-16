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
    var timestamp: Date!
    let user: User
    var comment: String?
    var shopID: String?
    
    init(user: User, spotID: String, dictionary: [String: Any]) {
        self.user = user
        self.spotID = spotID
        
        if let shopID = dictionary["shopID"] as? String{
            self.shopID = shopID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let comment = dictionary["comment"] as? String {
            self.comment = comment
        }
    }
}
