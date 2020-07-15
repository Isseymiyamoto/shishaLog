//
//  Shop.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation


struct Shop {
    
    let shopID: String
    let address: String
    let price: Int
    let comment: String
    
    init(shopID: String, dictionary: [String: Any]) {
        self.shopID = shopID
        
        self.address = dictionary["address"] as? String ?? ""
        self.price = dictionary["price"] as? Int ?? 0
        self.comment = dictionary["comment"] as? String ?? ""
    }
    
}
