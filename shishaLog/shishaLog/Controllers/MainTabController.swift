//
//  MainTabController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case log
    case spot
}


class MainTabController: UITabBarController{
    
    // MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .log
    
    var user: User? {
        didSet{
            configureViewControllers()
            // MainTabのuserに情報がセットされた時点でfeedControllerにもセットする
            guard let nav = viewControllers![0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .shishaColor
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        authenticateUserAndConfigureUI()
    }
    
    
    // MARK: - API
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { (user) in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }else{
//            configureViewControllers()
            fetchUser()
            configureUI()
            
        }
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonTapped(){
        if buttonConfig == .log{
            guard let user = user else { return }
            let controller = UploadLogController(user: user)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        
        if buttonConfig == .spot{
            print("DEBUG: not finished")
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        self.delegate = self
        view.backgroundColor = .white
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers(){
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: explore)
        
        let spot = SpotFeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav3 = templateNavigationController(image: UIImage(systemName: "location"), rootViewController: spot)
        
        let profile = ProfileController(user: user!)
        let nav4 = templateNavigationController(image: UIImage(systemName: "person"), rootViewController: profile)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        return nav
    }

}

extension MainTabController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // firstIndex(of:) で、配列内における引数に該当する要素が出てきた最初の配列番目を返すようにする
        // つまり、MainTabBarで定義されたviewControllersにおいてdidSelectされたviewControllerが配列の何番目かを返す
        let index = viewControllers?.firstIndex(of: viewController)
        let image = index == 2 ? UIImage(systemName: "location") : UIImage(systemName: "square.and.pencil")
        actionButton.setImage(image, for: .normal)
        buttonConfig = index == 2 ? .spot : .log
    }
}
