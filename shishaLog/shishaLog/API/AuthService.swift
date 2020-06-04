//
//  AuthService.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func loginUser(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        print("DEBUG: email is \(email)")
        print("DEBUG: password is \(password)")
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference)-> Void) {
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        // 生成される度に異なる文字列を返す
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGE.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (mata, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error{
                        print("DEBUG: error is \(error.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    
                }
                
            }
        }
        
        
        
    }
}
