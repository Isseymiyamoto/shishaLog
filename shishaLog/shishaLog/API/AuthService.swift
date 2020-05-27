//
//  AuthService.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase


struct AuthService {
    static let shared = AuthService()
    
    func loginUser(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        print("DEBUG: email is \(email)")
        print("DEBUG: password is \(password)")
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
}
