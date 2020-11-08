//
//  User.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/09.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation
import Firebase


struct User {
    var fullname: String
    let email: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var bio: String?
    var isFollowing: Bool = false
    var isBlocking: Bool = false
    var userStatus: UserStatus = .notFollowing
    var stats: UserRelationStats?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let bio = dictionary["bio"] as? String{
            self.bio = bio
        }
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String{
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}

enum UserStatus{
    case notFollowing
    case following
    case blocking
}
