//
//  SpotViewModel.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/20.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation
import UIKit


struct SpotViewModel {
    
    // MARK: - Properties
    
    private let spot: Spot
    private let user: User
    private let shop: Shop
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: spot.timestamp, to: now) ?? "2m"
    }
    
    var userInfoText: NSAttributedString{
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    
    // MARK: - Lifecycle
    
    init(spot: Spot) {
        self.spot = spot
        self.user = spot.user
        self.shop = spot.shop
    }
}
