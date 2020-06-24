//
//  EditProfileController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/24.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EditProfileCell"

class EditProfileController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)

    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()

       
    }
    
    // MARK: - Helpers
    
    func configureTableView(){
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
    }

}

// MARK: - UITableViewDataSource / Delegate

extension EditProfileController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        return cell
    }
}

extension EditProfileController: EditProfileHeaderDelegate{
    func didTapChengeProfilePhoto() {
        print("DEBUG: user is tapping didTapChangePhoto button")
    }
}

