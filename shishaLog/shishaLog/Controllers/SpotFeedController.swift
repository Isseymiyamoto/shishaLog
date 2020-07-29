//
//  NotificationsController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SpotCell"

class SpotFeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var spots = [Spot](){
        didSet{ collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configure()
        fetchSpots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - API
    
    func fetchSpots(){
        collectionView.refreshControl?.beginRefreshing()
        
        SpotService.shared.fetchSpots { (spots) in
            self.spots = spots.sorted(by: { $0.timestamp > $1.timestamp })
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func handleRefresh(){
        fetchSpots()
    }
    
    
    // MARK: - Helpers
    
    func configureNavigationBar(){
        navigationItem.title = "スポット"
    }
    
    func configure(){
        view.backgroundColor = .white
        collectionView.register(SpotCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        // refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    
}

// MARK: - UICollectionViewDelegate / DataSource

extension SpotFeedController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SpotCell
        cell.spot = spots[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let spot = spots[indexPath.item] as Spot? else { return }
        let controller = SpotController(spot: spot)
        controller.indexValue = indexPath.item
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpotFeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension SpotFeedController: SpotCellDelegate{
    func handleProfileImageTapped(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SpotControllerDelegate

extension SpotFeedController: SpotControllerDelegate{
    func controller(_ controller: SpotController) {
        spots.remove(at: controller.indexValue!)
        controller.navigationController?.popViewController(animated: true)
        self.collectionView.reloadData()
    }
}
