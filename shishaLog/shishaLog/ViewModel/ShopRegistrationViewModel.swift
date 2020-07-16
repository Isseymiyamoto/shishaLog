//
//  ShopRegistrationViewModel.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/16.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation
import UIKit

struct ShopRegistrationViewModel {
    var shopName: String?
    var shopAddress: String?
    var shopImage: UIImage?
    
    var formIsValid: Bool {
        return shopName?.isEmpty == false && shopAddress?.isEmpty == false && shopImage !== nil
    }
}
