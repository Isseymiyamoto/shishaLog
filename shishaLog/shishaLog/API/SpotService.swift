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
    
    func uploadSpot(shopID: String, comment: String, completion: @escaping((Error?, DatabaseReference) -> Void)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "uid": uid,
            "shopID": shopID,
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
            let spotID = snapshot.key 
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                ShopService.shared.fetchSomeShop(shopID: shopID) { (shop) in
                    let spot = Spot(user: user, spotID: spotID, shop: shop, dictionary: dictionary)
                    spots.append(spot)
                    completion(spots)
                }
            }
        }
    }
    
    // 自分のspot取得
    func fetchMySpot(forUser user: User, completion: @escaping(([Spot]) -> Void)){
        var spots = [Spot]()
        
        REF_USER_SPOTS.child(user.uid).observe(.childAdded) { (snapshot) in
            let spotID = snapshot.key
            self.fetchSpot(withSpotID: spotID) { (spot) in
                spots.append(spot)
                completion(spots)
            }
            
        }
        
    }
    
    // spotIDを指定してspot取得
    func fetchSpot(withSpotID spotID: String, completion: @escaping(Spot) -> Void){
        REF_SPOTS.child(spotID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            guard let shopID = dictionary["shopID"] as? String else { return }
            let spotID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                ShopService.shared.fetchSomeShop(shopID: shopID) { (shop) in
                    let spot = Spot(user: user, spotID: spotID, shop: shop, dictionary: dictionary)
                    completion(spot)
                }
            }
        }
    }
    
    func deleteSpot(withSpotID spotID: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_SPOTS.child(spotID).removeValue { (error, ref) in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            REF_USER_SPOTS.child(uid).child(spotID).removeValue(completionBlock: completion)
        }
    }
    
    // userによるログに関するレポート送信
    func reportSpot(spotID: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_REPORT_SPOTS.child(spotID).setValue([uid: 1])
    }
    
}
