//
//  ProfileHeaderViewModel.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/19.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation
import UIKit

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

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "プロフィールを編集する"
        }
        
        switch user.userStatus {
        case .notFollowing:
            return "フォローする"
        case .following:
            return "フォロー中"
        case .blocking:
            return "ブロック中"
        }
    }
    
    var actionButtonBackGroundColor: UIColor{
        if user.userStatus == .blocking{
            return UIColor.rgb(red: 224, green: 36, blue: 94)
        }else{
            return .shishaColor
        }
    }
    
    var followingLabelText: String?{
        return "\(user.stats?.following ?? 0)"
    }
    
    var followersLabelText: String?{
        return "\(user.stats?.followers ?? 0)" 
    }
    
    var bioLabelText: String?{
        return user.bio ?? ""
    }
    
    
    
    init(user: User) {
        self.user = user
    }
}


