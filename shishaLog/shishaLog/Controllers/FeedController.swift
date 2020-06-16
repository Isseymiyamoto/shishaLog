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
    var user: User? {
        didSet{
            print("DEBUG: test")
        }
    }
    
    private var logs = [Log]() {
        didSet { collectionView.reloadData() }
    }
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchLogs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - API
    
    func fetchLogs(){
        LogService.shared.fetchLog { (logs) in
            self.logs = logs.sorted(by: { $0.timestamp  > $1.timestamp })
        }
    }
    
    
    
    
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
        // test的に
        cell.user = user
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

