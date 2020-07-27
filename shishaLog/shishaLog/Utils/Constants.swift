//
//  Constants.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Firebase
import FirebaseStorage

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGE = STORAGE_REF.child("profile_images")
let STORAGE_SHOP_IMAGE = STORAGE_REF.child("shop_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_LOGS = DB_REF.child("logs")
let REF_USER_LOGS = DB_REF.child("user-logs")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_LOG_LIKES = DB_REF.child("log-likes")
let REF_SHOPS = DB_REF.child("shops")
let REF_SPOTS = DB_REF.child("spots")
let REF_USER_SPOTS = DB_REF.child("user-spots")
let REF_REPORT_LOGS = DB_REF.child("report-logs")
