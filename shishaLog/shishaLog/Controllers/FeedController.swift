//
//  FeedController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LogCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        
    }
    
    
    // MARK: - API
    
    
    
    
    // MARK: - Selectors
    
    
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        // Register cell classes
        collectionView!.register(LogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        // 後でlogo入れる
        let imageView = UIImageView(image: UIImage(systemName: "pencil.circle"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 32, height: 32)
        navigationItem.titleView = imageView
        
        
    }

    

    

}

// MARK: UICollectionViewDelegate / DataSource

extension FeedController{

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Logを詳しく見るためのLogControllerにでも飛ばそう
//    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
 
    
}

