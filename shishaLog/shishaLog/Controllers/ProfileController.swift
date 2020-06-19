//
//  ProfileController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LogCell"
private let headerIdentifier = "ProfileHeader"


class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var user: User
    
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureNavigationBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - API
    
    func fetchLogs(){
        
    }
    
    func fetchLikeLogs(){
        
    }
    
    
    // MARK: - Helpers
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        // cell等を登録
        self.collectionView!.register(LogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
        
    }
    
    func configureNavigationBar(){
        navigationItem.title = user.username
    }
    

}

// MARK: UICollectionViewDataSource

extension ProfileController{

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        return cell
    }
    
}

// MARK: UICollectionViewDelegate

extension ProfileController{
    
    // headerを適用する
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        return header
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    // headerのsizeを決める
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = 420
        return CGSize(width: view.frame.width, height: height)
    }
    
}
