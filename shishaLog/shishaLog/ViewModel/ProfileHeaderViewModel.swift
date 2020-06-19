//
//  ProfileHeaderViewModel.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/19.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation

enum ProfileFilterOptions: Int, CaseIterable {
    case logs
    case locations
    case likeLogs
    
    var description: String{
        switch self {
        case .logs: return "ログ"
        case .locations: return "スポット"
        case .likeLogs: return "お気に入り"
        }
    }
}


