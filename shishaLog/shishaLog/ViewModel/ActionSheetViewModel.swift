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
            let followOption: ActionSheetOptions?
            switch user.userStatus{
            case .notFollowing:
                followOption = .follow(user)
            case .following:
                followOption = .unfollow(user)
            case .blocking:
                followOption = .follow(user)
            }
//            let followOption: ActionSheetOptions = user.isFollowing ? .unfollow(user) : .follow(user)
            results.append(followOption!)
            results.append(.block(user))
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

enum ActionSheetOptions{
    case follow(User)
    case unfollow(User)
    case report
    case delete
    case block(User)
    case unblock(User)
    
    var descriptionForLog: String{
        switch self {
        case .follow(let user): return "フォロー @\(user.username)"
        case .unfollow(let user): return "アンフォロー @\(user.username)"
        case .block(let user): return "ブロック @\(user.username)"
        case .unblock(let user): return "アンブロック @\(user.username)"
        case .report: return "ログを報告"
        case .delete: return "ログを削除"
        }
    }
    
    var descriptionforSpot: String{
        switch self {
        case .follow(let user): return "フォロー @\(user.username)"
        case .unfollow(let user): return "アンフォロー @\(user.username)"
        case .block(let user): return "ブロック @\(user.username)"
        case .unblock(let user): return "アンブロック @\(user.username)"
        case .report: return "スポットを報告"
        case .delete: return "スポットを削除"
        }
    }
    
    var descriptionForProfile: String {
        switch self {
        case .follow(let user): return "フォロー @\(user.username)"
        case .unfollow(let user): return "アンフォロー @\(user.username)"
        case .block(let user): return "ブロック @\(user.username)"
        case .unblock(let user): return "アンブロック @\(user.username)"
        case .report: return "ユーザーを報告"
        case .delete: return "ユーザーを削除"
        }
    }
}
