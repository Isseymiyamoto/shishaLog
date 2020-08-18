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
    var user: User? 
    
    private var logs = [Log]() {
        didSet {
            collectionView.reloadData()
            configureBackGroundView()
        }
    }
    
    private lazy var noContentsView: NoContentsView = {
        let nc = NoContentsView(option: .logs)
        nc.isHidden = true
        return nc
    }()
    
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
        
        LogService.shared.fetchFollowingLogs { (logs) in
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
//        let imageView = UIImageView(image: UIImage(systemName: "pencil.circle"))
        let imageView = UIImageView(image: UIImage(named: "shishaLog_theme"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 32, height: 32)
        imageView.layer.cornerRadius = 32 / 2
        navigationItem.titleView = imageView
        
        // refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        collectionView.addSubview(noContentsView)
        noContentsView.delegate = self
        noContentsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
    }
    
    // 表示するコンテンツがない場合、backgroundViewにNoContentsViewを表示
    func configureBackGroundView(){
        if logs.isEmpty {
            noContentsView.isHidden = false
            noContentsView.isUserInteractionEnabled = true
        }else{
            noContentsView.isHidden = true
            noContentsView.isUserInteractionEnabled = false
        }
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LogCell else { return }
        guard let log = cell.log else { return }
        
        let controller = LogController(log: log)
        controller.delegate = self
        controller.indexValue = indexPath.item
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 200
        return CGSize(width: view.frame.width, height: height)
//        let viewModel = LogViewModel(log: logs[indexPath.item])
//        let size = viewModel.size(withWidth: view.frame.width)
//        return size
    }
 
    
}

// MARK: - LogCellDelegate

extension FeedController: LogCellDelegate{
    func handleLocationLabelTapped(shop: Shop) {
        let controller = ShopController(shop: shop)
        navigationController?.pushViewController(controller, animated: true)
    }
    
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

// MARK: - LogControllerDelegate

extension FeedController: LogControllerDelegate{
    func controller(_ controller: LogController) {
        logs.remove(at: controller.indexValue!)
        controller.navigationController?.popViewController(animated: true)
        self.collectionView.reloadData()
    }
}


// MARK: - NoContentsViewDelegate

extension FeedController: NoContentsViewDelegate{
    func handlePromotionButtonTapped() {
        print("DEBUG: きてるで")
        
        guard let user = user else { return }
        let controller = UploadLogController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
