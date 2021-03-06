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

protocol LogControllerDelegate: class {
    func controller(_ controller: LogController)
}

class LogController: UICollectionViewController {
    
    // MARK: - Properties
    
    var indexValue: Int?
    weak var delegate: LogControllerDelegate?
    private var log: Log
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
        self.collectionView.register(LogHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: logHeaderIdentifier)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "ログ"
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    fileprivate func showActionSheet(forUser user: User){
        actionSheetLauncher = ActionSheetLauncher(user: user, isLog: true, isProfile: false)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
    fileprivate func showSuccessReportMessage(){
        let alert = UIAlertController(title: "コンテンツの報告", message: "不快なコンテンツの報告を行いました。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            self.delegate?.controller(self)
        }))
        present(alert, animated: true)
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: logHeaderIdentifier, for: indexPath) as! LogHeaderSupplementaryView
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
        return CGSize(width: view.frame.width, height: 280)
    }
}

// MARK: - LogHeaderDelegate

extension LogController: LogHeaderDelegate{
    func handleLocationLabelTapped(shop: Shop) {
        let controller = ShopController(shop: shop)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleLikesLabelTapped() {
        let logID = log.logID
        let controller = UserListController(option: .likeUser, logID: logID)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showActionSheet() {
        if log.user.isCurrentUser{
            showActionSheet(forUser: log.user)
        }else{
            UserService.shared.checkIfUserIsFollowed(uid: log.user.uid) { (isFollowed) in
                self.log.user.userStatus = isFollowed ? .following : .notFollowing
                self.showActionSheet(forUser: self.log.user)
            }
        }
    }
    
    func handleLikeButtonTapped(_ header: LogHeaderSupplementaryView) {
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
        controller.checkUserStatus { (status) in
            controller.user.userStatus = status!
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
            LogService.shared.reportLog(logID: logID) { (err, ref) in
                self.showSuccessReportMessage()
            }
        case .delete:
            let logID = log.logID
            LogService.shared.deleteLog(withLogID: logID) { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                LogService.shared.deleteSomeUserLikes(withLogID: logID)
                self.delegate?.controller(self)
            }
        case .block(let user):
            let blockUid = user.uid
            
            UserService.shared.blockUser(blockUid: blockUid) { (err, ref) in
                if let err = err{
                    print("DEBUG: error is \(err.localizedDescription)")
                    return
                }

                // 当該ユーザーをfollowしていた際の処理
                if self.log.user.userStatus == .following{
                    UserService.shared.unfollowUser(uid: blockUid) { (error, ref) in
                        if let error = error {
                            print("DEBUG: error is \(error.localizedDescription)")
                            return
                        }
                        print("DEBUG: unfollow 成功")
                    }
                }
                
                self.log.user.userStatus = .blocking
                self.delegate?.controller(self)
            }
        case .unblock(_):
            print("DEBUG: 今後追加しますよ")
        }
    }
}




