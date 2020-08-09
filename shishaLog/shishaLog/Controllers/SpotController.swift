//
//  SpotController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/29.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SpotHeader"
private let spotCellIdentifier = "SpotCell"

protocol SpotControllerDelegate: class {
    func controller(_ controller: SpotController)
}

class SpotController: UICollectionViewController {
    
    // MARK: - Properties
    var indexValue: Int?
    weak var delegate: SpotControllerDelegate?
    private let spot: Spot
    private var actionSheetLauncher: ActionSheetLauncher!
    
    // MARK: - Lifecycle
    
    init(spot: Spot) {
        self.spot = spot
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollecitonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Helpers
    
    func configureCollecitonView(){
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        configureNavigationBar()
        
        collectionView.register(SpotHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "スポット"
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    fileprivate func showActionSheet(forUser user: User){
        actionSheetLauncher = ActionSheetLauncher(user: user, isLog: false)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}


// MARK: UICollectionViewDataSource / Delegate

extension SpotController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! SpotHeaderSupplementaryView
        header.delegate = self
        header.spot = spot
        return header
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpotController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}


// MARK: - SpotHeaderDelegate

extension SpotController: SpotHeaderDelegate{
    func handleLocationButtonTapped(shop: Shop) {
        let controller = ShopController(shop: shop)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleProfileImageTapped(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showActionSheet() {
        if spot.user.isCurrentUser {
            showActionSheet(forUser: spot.user)
        }else{
            UserService.shared.checkIfUserIsFollowed(uid: spot.user.uid) { (isFollowed) in
                var user = self.spot.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

// MARK: - ActionSheetLauncherDelegate

extension SpotController: ActionSheetLauncherDelegate{
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            let uid = user.uid
            UserService.shared.followUser(uid: uid) { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                print("DEBUG: follow 成功")
            }
        case .unfollow(let user):
            let uid = user.uid
            UserService.shared.unfollowUser(uid: uid) { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                print("DEBUG: unfollow 成功")
            }
        case .delete:
            let spotID = spot.spotID 
            SpotService.shared.deleteSpot(withSpotID: spotID) { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                self.delegate?.controller(self)
            }
        case .report:
            let spotID = spot.spotID
            SpotService.shared.reportSpot(spotID: spotID)
        }
    }
}
