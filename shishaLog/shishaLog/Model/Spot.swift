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
    var shop: Shop
    var comment: String?
    
    
    init(user: User, spotID: String, shop: Shop, dictionary: [String: Any]) {
        self.user = user
        self.shop = shop
        self.spotID = spotID
        
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let comment = dictionary["comment"] as? String {
            self.comment = comment
        }
    }
}
