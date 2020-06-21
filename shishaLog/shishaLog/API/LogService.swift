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
    
}
