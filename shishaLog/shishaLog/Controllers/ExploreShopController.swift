//
//  ExploreShopController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/11/19.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let identifier = "ShopCell"

class ExploreShopController: UITableViewController {
    
    //　MARK: - Properties
    
    private var shops = [Shop](){
        didSet{ tableView.reloadData() }
    }
    
    private var filteredShops = [Shop](){
        didSet{ tableView.reloadData() }
    }
    
    private var isSearchMode: Bool {
        return true
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - API
    

    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "シーシャ屋を探す"
        tableView.register(ChoiceSpotCell.self, forCellReuseIdentifier: identifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .systemBlue
        searchController.searchBar.placeholder = "今いるシーシャ屋を探してみよう"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
    }
    
    

   

}


// MARK: - UITableViewDataSource / Delegate

extension ExploreShopController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredShops.count : shops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChoiceSpotCell
        let shop = isSearchMode ? filteredShops[indexPath.row] : shops[indexPath.row]
        cell.shop = shop
        return cell
    }
    
}

// MARK: - UISearchResultsUpdating

extension ExploreShopController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredShops = shops.filter({ $0.address.contains(searchText) || $0.shopName.contains(searchText)})
    }
}
