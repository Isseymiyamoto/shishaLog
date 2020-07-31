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
    
    private var users = [User]() {
        didSet{ tableView.reloadData() }
    }
    var option: UserListOptions
    
    // MARK: - Lifecycle
    
    init(option: UserListOptions) {
        self.option = option
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    
    // MARK: - API
    
    func fetchLogLikesUser(){
        
    }
    
    func fetchFollowingUser(){
        
    }
    
    func fetchFollowedUser(){
        
    }
    
    
    
    // MARK: - Helpers
    
    func configureTableView(){
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: identifier)
    }
    
    func fetchSomeUsers(){
        
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension UserListController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: did tapped \(indexPath.row)th item")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}



