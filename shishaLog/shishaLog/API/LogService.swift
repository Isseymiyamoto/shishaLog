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
        
        print("DEBUG: uid is \(uid)")
        
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
}
