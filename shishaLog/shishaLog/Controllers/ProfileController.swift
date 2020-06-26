//
//  ProfileController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "LogCell"
private let headerIdentifier = "ProfileHeader"


class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .logs{
        didSet{ collectionView.reloadData() }
    }
    
    // ログに入るデータを格納
    private var logs = [Log]()
    // スポットに入るデータを格納予定(後で)(暫定的に適当にLogを入れている)
    private var spots = [Log]()
    // お気に入りのログに関するデータを格納
    private var likeLogs = [Log]()
    
    private var currentDataSource: [Log]{
        switch selectedFilter {
        case .logs: return logs
        case .likeLogs: return likeLogs
        case .locations: return spots
        }
    }
    
    
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
        fetchLogs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - API
    
    func fetchLogs(){
        LogService.shared.fetchMyLogs(forUser: user) { (logs) in
            self.logs = logs.sorted(by: { $0.timestamp > $1.timestamp })
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikeLogs(){
        
    }
    
    // spotに関するものも追加予定
    func fetchSpots(){
        LogService.shared.fetchLogs { (logs) in
            self.spots = logs.sorted(by: { $0.timestamp > $1.timestamp })
            self.collectionView.reloadData()
        }
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
        return logs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LogCell
        cell.log = logs[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ProfileController{
    
    // headerを適用する
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 160)
    }
    
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate{
    func handleEditProfile(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
        
        else{
            print("DEBUG: this user is not you")
        }
        // ユーザーがFollowing or notで分岐させる
    }
    
    func didSelect(filter: ProfileFilterOptions) {
        print(" DEBUG: didSelect FilterView on \(filter.description)")
    }
    
    
}

extension ProfileController: EditProfileControllerDelegate{
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
        self.collectionView.reloadData()
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }catch let error{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    
}
