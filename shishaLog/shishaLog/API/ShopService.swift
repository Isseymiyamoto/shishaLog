//
//  ShopService.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Firebase

struct ShopCredentials {
    let shopName: String
    let shopAddress: String
    let shopImage: UIImage
}

struct ShopService {
    
    static let shared = ShopService()
    
    // shop情報の登録を行う
    func registerShop(credentials: ShopCredentials, completion: @escaping(Error?, DatabaseReference) -> Void){
        
        guard let imageData = credentials.shopImage.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_SHOP_IMAGE.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                }
                guard let shopImageUrl = url?.absoluteString else { return }
                
                let values = [
                    "shopName": credentials.shopName,
                    "shopAddress": credentials.shopAddress,
                    "shopImageUrl": shopImageUrl,
                ] as [String: Any]
                
                REF_SHOPS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
            }
        }
    }
    
    func fetchAllShops(completion: @escaping(([Shop]) -> Void)){
        var shops = [Shop]()
        
        REF_SHOPS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let shop = Shop(shopID: snapshot.key, dictionary: dictionary)
            shops.append(shop)
            completion(shops)
        }
    }
    
    // 一件だけ取得
    func fetchSomeShop(shopID: String, completion: @escaping(Shop) -> Void){
        REF_SHOPS.child(shopID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let shop = Shop(shopID: shopID, dictionary: dictionary)
            completion(shop)
        }
    }
    
}
