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

class ChoiceSpotController: UITableViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    private var shops = [Shop]() {
        didSet { tableView.reloadData() }
    }
    
    private var filteredShops = [Shop]() {
        didSet{ tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleShowSearchBar(){
        
    }

    // MARK: - Helpers
    
    func configureTableView(){
        tableView.backgroundColor = .white
        configureNavigationBar()
        
        tableView.register(ChoiceSpotCell.self, forCellReuseIdentifier: choiseCellIdentifier)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "今どこ？"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleShowSearchBar))
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
            return 20
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
            let controller = ShopRegistrationController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        default:
            return
        }
    }
}
