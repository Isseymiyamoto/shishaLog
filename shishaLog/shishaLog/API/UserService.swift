//
//  UserService.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation


struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion:@escaping(User) -> Void){
        REF_USERS.child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
