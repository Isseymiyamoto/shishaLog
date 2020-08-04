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

enum ChoiceSpotControllerOptions{
    case fromUploadLog
    case fromSpotFeed
    
    var description: String {
        switch self {
        case .fromUploadLog:
            return "Spotを選択"
        case .fromSpotFeed:
            return "今どこ？"
        }
    }
}
