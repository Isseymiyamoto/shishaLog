//
//  SpotService.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation
import Firebase

struct SpotService {
    static let shared = SpotService()
    
    func uploadSpot(spotID: String, comment: String, completion: @escaping((Error?, DatabaseReference) -> Void)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "uid": uid,
            "spotID": spotID,
            "comment": comment,
            "timestamp": Int(NSDate().timeIntervalSince1970)
        ] as [String: Any]
        
        REF_SPOTS.childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            
            guard let spotID = ref.key else { return }
            REF_USER_SPOTS.child(uid).updateChildValues([spotID: 1], withCompletionBlock: completion)
        }
    }
    
    // spot全件取得
    func fetchSpots(completion: @escaping(([Spot]) -> Void)){
        var spots = [Spot]()
        
        REF_SPOTS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            guard let shopID = dictionary["shopID"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                ShopService.shared.fetchSomeShop(shopID: shopID) { (shop) in
                    let spot = Spot(user: user, shop: shop, dictionary: dictionary)
                    spots.append(spot)
                    completion(spots)
                }
            }
        }
    }
    
    
    
}
