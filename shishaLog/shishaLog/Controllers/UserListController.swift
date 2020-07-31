//
//  UserListController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/31.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class UserListController: UITableViewController {
    
    // MARK: - Properties
    
    private var users: [User]
    
    
    
    // MARK: - Lifecycle
    
    init(users: [User]) {
        self.users = users
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - API
    
    
    
    // MARK: - Helpers
    
    func configureTableView(){
        
    }
    
    
    
    
}
