//
//  FeedController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase

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
        collectionView.refreshControl?.beginRefreshing()
        
        LogService.shared.fetchLogs { (logs) in
            self.logs = logs.sorted(by: { $0.timestamp  > $1.timestamp })
            self.checkIfUserLikedLogs()
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedLogs(){
        self.logs.forEach { (log) in
            LogService.shared.checkIfUserLikedLog(log) { (didLike) in
                guard didLike == true else { return }
                
                if let index = self.logs.firstIndex(where: { $0.logID == log.logID }) {
                    print("DEBUG: index is \(index) in feed controller")
                    self.logs[index].didLike = true
                }
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleRefresh(){
        fetchLogs()
    }
    
    
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
        
        // refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}

// MARK: UICollectionViewDelegate / DataSource

extension FeedController{

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        cell.log = logs[indexPath.row]
        cell.delegate = self
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Logを詳しく見るためのLogControllerにでも飛ばそう
//    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 200
        return CGSize(width: view.frame.width, height: height)
    }
 
    
}

// MARK: - LogCellDelegate

extension FeedController: LogCellDelegate{
    func handleLikeButtonTapped(_ cell: LogCell) {
        guard let log = cell.log else { return }
        
        LogService.shared.likeLog(log: log) { (err, ref) in
            cell.log?.didLike.toggle()
            
            let likes = log.didLike ? log.likes - 1 : log.likes + 1
            cell.log?.likes = likes
        }
    }
    
    func handleProfileImageTapped(_ cell: LogCell) {
        guard let user = cell.log?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

