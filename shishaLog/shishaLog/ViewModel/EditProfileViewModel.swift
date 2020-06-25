//
//  EditProfileViewModel.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/25.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "名前"
        case .username: return "ユーザーネーム"
        case .bio: return "自己紹介"
        }
    }
}

struct EditProfileViewModel {
    
    // MARK: - Properties
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .fullname: return user.fullname
        case .username: return user.username
        case .bio: return user.bio
        }
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != nil
    }
    
    // MARK: - Lifecycle
    
    init(user: User, option: EditProfileOptions){
        self.user = user
        self.option = option
    }
    
}
