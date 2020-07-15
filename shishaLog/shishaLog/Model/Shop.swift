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
    let shopName: String
    let address: String
    var shopImageUrl: URL?
    var phoneNumber: String?
    
    init(shopID: String, dictionary: [String: Any]) {
        self.shopID = shopID
        
        self.address = dictionary["address"] as? String ?? ""
        self.shopName = dictionary["shopName"] as? String ?? ""
        
        if let shopImageUrl = dictionary["shopImageUrl"] as? String {
            self.shopImageUrl = URL(string: shopImageUrl)
        }
        
        if let phoneNumber = dictionary["phoneNumber"] as? String{
            self.phoneNumber = phoneNumber
        }
    }
    
}
