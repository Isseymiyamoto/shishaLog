//
//  UserService.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase


struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion:@escaping(User) -> Void){
        REF_USERS.child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping(URL?) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGE.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, err) in
            ref.downloadURL { (url, err) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageUrl": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    
    
    
    
}
