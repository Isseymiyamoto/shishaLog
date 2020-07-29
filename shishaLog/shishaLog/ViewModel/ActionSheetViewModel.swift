//
//  ActionSheetViewModel.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/25.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {

    // MARK: - Properties
    private let user: User
    
    var options: [ActionSheetOptions]{
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        }else{
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
        
        return results
    }
    
    
    // MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        
    }
    
    
    // MARK: - Helpers
    
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String{
        switch self {
        case .follow(let user): return "フォロー @\(user.username)"
        case .unfollow(let user): return "アンフォロー @\(user.username)"
        case .report: return "ログを報告"
        case .delete: return "ログを削除"
        }
    }
    
    var descriptionforSpot: String{
        switch self {
        case .follow(let user): return "フォロー @\(user.username)"
        case .unfollow(let user): return "アンフォロー @\(user.username)"
        case .report: return "スポットを報告"
        case .delete: return "スポットを削除"
        }
    }
}
