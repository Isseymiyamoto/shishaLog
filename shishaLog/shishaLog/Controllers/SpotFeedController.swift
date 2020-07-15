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
    
    
    // MARK: - Lifecycle
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - API
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureNavigationBar(){
        navigationItem.title = "スポット"
    }
    
    func configure(){
        collectionView.register(SpotCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    
    
    
}

// MARK: - UICollectionViewDelegate / DataSource

extension SpotFeedController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SpotCell
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpotFeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
