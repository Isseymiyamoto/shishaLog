//
//  ExploreController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class ExploreController: UITableViewController {
    
    // MARK: - Properties
    
    
    // UITableViewに検索バーを設ける
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "友達を探す"
        
    }
    
    // MARK: - API
    
    // 検索結果に表示するためのユーザーを取得する
    func fetchUsers(){
        
    }
    
    
    // MARK: - Helpers
    


}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ExploreController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
}
