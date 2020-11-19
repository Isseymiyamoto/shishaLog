//
//  ChoiceSpotController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let choiseCellIdentifier = "spotCell"
private let identifier = "addNewSpotCell"

protocol ChoiceSpotControllerDelegate: class {
    func controller(_ controller: ChoiceSpotController, shop: Shop)
}

class ChoiceSpotController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: ChoiceSpotControllerDelegate?
    private let user: User
    private let option: ChoiceSpotControllerOptions
    
    private var shops = [Shop]() {
        didSet { tableView.reloadData() }
    }
    
    private var filteredShops = [Shop]() {
        didSet{ tableView.reloadData() }
    }
    
    // 検索バー
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.tintColor = .systemBlue
        controller.searchBar.placeholder = "今いるシーシャ屋を探そう"
        controller.searchBar.sizeToFit()
        return controller
    }()
        
    
    // MARK: - Lifecycle
    
    init(user: User, option: ChoiceSpotControllerOptions) {
        self.user = user
        self.option = option
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        fetchShops()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - API
    
    func fetchShops(){
        ShopService.shared.fetchAllShops { (shops) in
            self.shops = shops
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        switch option {
        case .fromSpotFeed:
            self.dismiss(animated: true, completion: nil)
        case .fromUploadLog:
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleShowSearchBar(){
        
    }

    // MARK: - Helpers
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .systemBlue
        searchController.searchBar.placeholder = "今いるシーシャ屋を探そう"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        configureNavigationBar()
        
        tableView.register(ChoiceSpotCell.self, forCellReuseIdentifier: choiseCellIdentifier)
    }
    
    func configureNavigationBar(){
        navigationItem.title = option.description
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
}

// MARK: - UITableViewDataSource

extension ChoiceSpotController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            cell.textLabel!.text = "新しいシーシャ屋を追加する"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemBlue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: choiseCellIdentifier, for: indexPath) as! ChoiceSpotCell
            cell.shop = shops[indexPath.row]
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return shops.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 36
        default:
            return 64
        }
    }
    
    
}

// MARK: - UITableViewDelgate

extension ChoiceSpotController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let controller = option == .fromUploadLog ? ShopRegistrationController(isFromUploadLog: true) : ShopRegistrationController(isFromUploadLog: false)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        default:
            switch option {
            case .fromSpotFeed:
                let controller = UploadSpotController(user: user, shop: shops[indexPath.row])
                navigationController?.pushViewController(controller, animated: true)
            case .fromUploadLog:
                delegate?.controller(self, shop: shops[indexPath.row])
            }
        }
    }
}

// MARK: - UISearchResultUpdating

extension ChoiceSpotController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredShops = shops.filter({ $0.shopName.contains(searchText) || $0.address.contains(searchText) })
    }
}

// MARK: - ShopRegistratinoControllerDelegate

extension ChoiceSpotController: ShopRegistrationControllerDelegate{
    func controller(controller: ShopRegistrationController, isFromUploadLog: Bool, shop: Shop) {
        controller.dismiss(animated: true) {
            // 1. UploadLogControllerに遷移する場合
            if isFromUploadLog{
                self.delegate?.controller(self, shop: shop)
            }else{
                // 2. UploadSpotControllerに遷移する場合
                let controller = UploadSpotController(user: self.user, shop: shop)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
