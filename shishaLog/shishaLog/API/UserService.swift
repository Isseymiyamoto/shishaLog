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
    
    func saveUserData(user: User, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname": user.fullname,
                      "username": user.username,
                      "bio": user.bio ?? ""]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func followUser(uid: String, completion: @escaping((Error?, DatabaseReference) -> Void)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (error, ref) in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping((Error?, DatabaseReference) -> Void)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (error, ref) in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    // フォローしているユーザーか確認
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    // フォロー関連のステータスを取得
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void){
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    // フォローしているユーザーを取得
    func fetchFollowingUsers(currentUserUid: String, completion: @escaping([User]) -> Void){
        var users = [User]()
        REF_USER_FOLLOWING.child(currentUserUid).observe(.childAdded) { (snapshot) in
            let followingUid = snapshot.key
            self.fetchUser(uid: followingUid) { (user) in
                users.append(user)
                completion(users)
            }
        }
    }
    
    func fetchFollowedUsers(currentUserUid: String, completion: @escaping([User]) -> Void){
        var users = [User]()
        REF_USER_FOLLOWERS.child(currentUserUid).observe(.childAdded) { (snapshot) in
            let followerUid = snapshot.key
            self.fetchUser(uid: followerUid) { (user) in
                users.append(user)
                completion(users)
            }
        }
    }
    
    // ユーザーをブロックする
    func blockUser(blockUid: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_BLOCKING.child(currentUserUid).setValue([blockUid: 1]) { (err, ref) in
            if let error = err {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            REF_USER_BLOCKED.child(blockUid).setValue([currentUserUid: 1], withCompletionBlock: completion)
        }
    }
    
    // ブロックを解除する
    func unblockUser(unblockUid: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_BLOCKING.child(currentUserUid).child(unblockUid).removeValue { (error, ref) in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            
            REF_USER_BLOCKED.child(unblockUid).child(currentUserUid).removeValue(completionBlock: completion)
        }
    }
    
    // ブロック判定
    func checkIfUserIsBlocked(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_BLOCKING.child(currentUserUid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
        
    }
    
    // 自身がブロックしているユーザーのuidを取得する
    func fetchMyBlockingUser(completion: @escaping([String]) -> Void){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        var blockingUsersUid = [String]()
        REF_USER_BLOCKING.child(currentUserUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let blockingUserUid = snapshot.key as? String else { return }
            blockingUsersUid.append(blockingUserUid)
            completion(blockingUsersUid)
        }
    }
    
    func reportUser(reportUid: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        REF_REPORT_USERS.child(currentUserUid).setValue([reportUid: 1], withCompletionBlock: completion)
    }
}
