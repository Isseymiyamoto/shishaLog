//
//  LogController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LogCell"
private let logHeaderIdentifier = "LogHeader"

class LogController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let log: Log
    private var replies = [Log]() {
        didSet{ collectionView.reloadData() }
    }
    private var actionSheetLauncher: ActionSheetLauncher!
    
    
    // MARK: - Lifecycle
    
    init(log: Log){
        self.log = log
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Helpers
    
    
    func configureCollectionView(){
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        configureNavigationBar()
        
        self.collectionView!.register(LogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(LogHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: logHeaderIdentifier)
        
    }
    
    func configureNavigationBar(){
        navigationItem.title = "ログ"
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    fileprivate func showActionSheet(forUser user: User){
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
   

}

// MARK: - UICollectionViewDataSource / Delegate

extension LogController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        cell.log = replies[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: logHeaderIdentifier, for: indexPath) as! LogHeader
        header.log = log
        header.delegate = self
        return header
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension LogController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

// MARK: - LogHeaderDelegate

extension LogController: LogHeaderDelegate{
    func showActionSheet() {
        if log.user.isCurrentUser{
            showActionSheet(forUser: log.user)
        }else{
            let user = log.user
            showActionSheet(forUser: user)
        }
        
    }
    
    func handleLikeButtonTapped(_ header: LogHeader) {
        print("DEBUG: 処理は走っておりますよ")
        guard let log = header.log else { return }
        
        LogService.shared.likeLog(log: log) { (err, ref) in
            header.log?.didLike.toggle()
            
            let likes = log.didLike ? log.likes - 1 : log.likes + 1
            header.log?.likes = likes
        }
    }
    
    func handleProfileImageTapped(_ jumpToUser: User) {
        let controller = ProfileController(user: jumpToUser)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

// MARK: - ActionSheetLauncherDelegate

extension LogController: ActionSheetLauncherDelegate{
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
        case .report:
            let logID = log.logID
            LogService.shared.reportLog(logID: logID)
        case .delete:
            let logID = log.logID
            LogService.shared.deleteLog(withLogID: logID)
        }
    }
}




