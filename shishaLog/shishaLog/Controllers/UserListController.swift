//
//  UserListController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/31.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let identifier = "UserCell"

enum UserListOptions{
    case likeUser
    case followingUser
    case followedUser
}

class UserListController: UITableViewController {
    
    // MARK: - Properties
    
    let logID: String
    let option: UserListOptions
    private var users = [User]() {
        didSet{ tableView.reloadData() }
    }
    
    
    // MARK: - Lifecycle
    
    init(logID: String, option: UserListOptions) {
        self.logID = logID
        self.option = option
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        fetchSomeUsers()
    }
    
    
    // MARK: - API
    
    func fetchLogLikesUser(){
        LogService.shared.fetchLogLikesUserUid(logID: logID) { (snapshot) in
            let uid = snapshot.key
            UserService.shared.fetchUser(uid: uid) { (user) in
                self.users.append(user)
            }
        }
    }
    
    func fetchFollowingUser(){
        
    }
    
    func fetchFollowedUser(){
        
    }
    
    
    
    // MARK: - Helpers
    
    func configureTableView(){
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
//        tableView.separatorStyle = .none
        
        tableView.register(UserCell.self, forCellReuseIdentifier: identifier)
    }
    
    
    func fetchSomeUsers(){
        switch option {
        case .likeUser:
            fetchLogLikesUser()
        case .followingUser:
            fetchFollowingUser()
        case .followedUser:
            fetchFollowedUser()
        }
    }
    
    func configureNavigationBar(){
        switch option {
        case .likeUser:
            navigationItem.title = "いいねしたユーザー"
        case .followingUser:
            navigationItem.title = "フォロー中"
        case .followedUser:
            navigationItem.title = "フォロワー"
        }
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension UserListController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: did tapped \(indexPath.row)th item")
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 64
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG: users.count is \(users.count)")
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}



