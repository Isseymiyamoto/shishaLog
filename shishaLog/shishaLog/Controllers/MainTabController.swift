//
//  MainTabController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase

class MainTabController: UITabBarController{
    
    // MARK: - Properties
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        authenticateUserAndConfigureUI()
    }
    
    
    // MARK: - API
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: RegistrationController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }else{
            configureViewControllers()
            configureUI()
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .twitterBlue
    }
    
    func configureViewControllers(){
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(systemName: "house.fill"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: notifications)
        
        let profile = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav4 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: profile)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        return nav
    }
    
    
    
    
    
}
