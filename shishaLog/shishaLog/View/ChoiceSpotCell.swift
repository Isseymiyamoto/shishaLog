//
//  ChoiceSpotCell.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class ChoiceSpotCell: UITableViewCell {

    // MARK: - Properties
    
    private let shop: Shop
    
    
    // MARK: - Lifecycle
    
    init(shop: Shop) {
        self.shop = shop
        super.init(style: .default, reuseIdentifier: "ChoiceCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    

}
