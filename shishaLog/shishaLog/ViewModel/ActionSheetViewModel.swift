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
//            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            let followOption: ActionSheetOptions = .follow(user)
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
        case .follow(let user): return "Follow @\(user.username)"
        case .unfollow(let user): return "Unfollow @\(user.username)"
        case .report: return "Report Tweet"
        case .delete: return "Delete Tweet"
        }
    }
}
