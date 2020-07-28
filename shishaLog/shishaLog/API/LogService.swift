//
//  LogService.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/08.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Firebase

struct LogService {

    static let shared = LogService()
    
    func uploadLog(location: String, mix: String, feeling: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "uid": uid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "location": location,
            "mix": mix,
            "feeling": feeling
        ] as [String: Any]
        
        REF_LOGS.childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let logID = ref.key else { return }
            REF_USER_LOGS.child(uid).updateChildValues([logID: 1], withCompletionBlock: completion)
        }
    }
    
    
    // フォローしている人のみlogを全件取得
    func fetchFollowingLogs(completion: @escaping(([Log]) -> Void)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        var logs = [Log]()
        
        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { (snapshot) in
            let followingUid = snapshot.key
            
            REF_USER_LOGS.child(followingUid).observe(.childAdded) { (snapshot) in
                let logID = snapshot.key
                self.fetchLog(withLogID: logID) { (log) in
                    logs.append(log)
                    completion(logs)
                }
            }
        }
    }
    
    // logを全件取得
    func fetchLogs(completion: @escaping(([Log]) -> Void)){
        var logs = [Log]()
        
        REF_LOGS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let log = Log(user: user, logID: snapshot.key, dictionary: dictionary)
                logs.append(log)
                completion(logs)
            }
        }
    }
    
    // 自分のLogのみfetchする ProfileControllerのログで使用想定
    func fetchMyLogs(forUser user: User, completion: @escaping([Log]) -> Void){
        var logs = [Log]()
        REF_USER_LOGS.child(user.uid).observe(.childAdded) { (snapshot) in
            let logID = snapshot.key
            
            self.fetchLog(withLogID: logID) { (log) in
                logs.append(log)
                completion(logs)
            }
        }
    }
    
    func fetchLog(withLogID logID: String, completion: @escaping(Log) -> Void){
        REF_LOGS.child(logID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let log = Log(user: user, logID: logID, dictionary: dictionary)
                completion(log)
            }
        }
    }
    
    func likeLog(log: Log, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = log.didLike ? log.likes - 1 : log.likes + 1
        REF_LOGS.child(log.logID).child("likes").setValue(likes)
        
        if log.didLike {
            REF_USER_LIKES.child(uid).child(log.logID).removeValue { (err, ref) in
                REF_LOG_LIKES.child(log.logID).removeValue(completionBlock: completion)
            }
        }else{
            REF_USER_LIKES.child(uid).updateChildValues([log.logID: 1]) { (err, ref) in
                REF_LOG_LIKES.child(log.logID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Log]) -> Void){
        var logs = [Log]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { (snapshot) in
            let logID = snapshot.key
            self.fetchLog(withLogID: logID) { (log) in
                var log = log
                log.didLike = true
                logs.append(log)
                completion(logs)
            }
        }
    }
    
    func checkIfUserLikedLog(_ log: Log, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(log.logID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
        
    }
    
    // userによるログに関するレポート送信
    func reportLog(logID: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_REPORT_LOGS.child(logID).setValue([uid: 1])
    }
    
    // 指定したログの削除
    func deleteLog(withLogID logID: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }

        REF_LOGS.child(logID).removeValue { (error, ref) in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            REF_USER_LOGS.child(uid).removeValue { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                self.deleteSomeUserLikes(withLogID: logID) { (result) in
                    if result{
                        REF_LOG_LIKES.child(logID).removeValue()
                    }else{
                        return
                    }
                }
            }
        }
    }
    
    // 削除するログに対して、likeしているユーザーを取得し、user-likesから削除する
    func deleteSomeUserLikes(withLogID logID: String, completion: @escaping(Bool) -> Void){
        REF_LOG_LIKES.child(logID).observe(.value) { (snapshot) in
            if !snapshot.exists(){
                completion(false)
                return
            }else{
                let likeUserUid = snapshot.key
                REF_USER_LIKES.child(likeUserUid).child(logID).removeValue()
                completion(true)
            }
        }
    }
    
}
