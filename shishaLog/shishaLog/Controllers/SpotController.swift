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

class SpotController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let spot: Spot
    
    
    
    
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
        
        
    }
    
    
    // MARK: - Helpers
    
    func configureCollecitonView(){
        collectionView.backgroundColor = .white
        
        collectionView.register(SpotHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
    }
}


// MARK: UICollectionViewDataSource / Delegate

extension SpotController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! SpotHeader
        header.delegate = self
        header.spot = spot
        return header
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpotController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}


// MARK: - SpotHeaderDelegate

extension SpotController: SpotHeaderDelegate{
    func handleProfileImageTapped(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showActionSheet() {
        print("DEBUG: show action sheet here...")
    }
    
    
}
