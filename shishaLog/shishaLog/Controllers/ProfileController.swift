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
private let fileterViewIdentifier = "ProfileFilterView"
private let spotCellIdentifier = "SpotCell"
private let blockUserViewIdentifier = "UserBlockView"


class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User
    
    private var selectedFilter: ProfileFilterOptions = .logs{
        didSet{ collectionView.reloadData() }
    }
    
    // ログに入るデータを格納
    private var logs = [Log]()
    // スポットに入るデータを格納
    private var spots = [Spot]()
    // お気に入りのログに関するデータを格納
    private var likeLogs = [Log]()
    
    private var currentDataSource: [Any]{
        switch selectedFilter {
        case .logs: return logs
        case .likeLogs: return likeLogs
        case .locations: return spots
        }
    }
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
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
        
        if user.userStatus == .blocking{
            configureCollectionView()
            configureNavigationBar()
            fetchUserStats()
        }else{
            configureCollectionView()
            configureNavigationBar()
            fetchLogs()
            fetchLikeLogs()
            fetchSpots()
            fetchUserStats()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .systemBlue
        
        fetchUserStats()
    }
    
    
    // MARK: - API
    
    func fetchLogs(){
        collectionView.refreshControl?.beginRefreshing()
        
        LogService.shared.fetchMyLogs(forUser: user) { (logs) in
            self.logs = logs.sorted(by: { $0.timestamp > $1.timestamp })
            self.collectionView.reloadData()
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func fetchLikeLogs(){
        collectionView.refreshControl?.beginRefreshing()
        
        LogService.shared.fetchLikes(forUser: user) { (logs) in
            self.likeLogs = logs.sorted(by: { $0.timestamp > $1.timestamp })
            self.collectionView.reloadData()
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // spotに関するものも追加予定
    func fetchSpots(){
        collectionView.refreshControl?.beginRefreshing()
        
        SpotService.shared.fetchMySpot(forUser: user) { (spots) in
            self.spots = spots.sorted(by: { $0.timestamp > $1.timestamp })
            self.collectionView.reloadData()
        }
        
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    // ブロック時に何もしない際
    func whenBlockRefresh(){
        collectionView.refreshControl?.beginRefreshing()
        collectionView.refreshControl?.endRefreshing()
    }
    
    
    // フォローしているか確認
    func checkIfUserIsFollowing(){
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (followResult) in
            if followResult{
                self.user.userStatus = .following
                self.collectionView.reloadData()
            }else{
                // ブロックしているか確認する
                UserService.shared.checkIfUserIsBlocked(uid: self.user.uid) { (blockResult) in
                    self.user.userStatus = blockResult ? .blocking : .notFollowing
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // profileControllerに遷移する前にテスト的にcheckUserStatusをする
    func checkUserStatus(completion: @escaping(UserStatus?) -> Void){
        var userStatus: UserStatus?
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (followResult) in
            if followResult{
                userStatus = .following
                completion(userStatus)
            }else{
                // ブロックしているか確認する
                UserService.shared.checkIfUserIsBlocked(uid: self.user.uid) { (blockResult) in
                    userStatus = blockResult ? .blocking : .notFollowing
                    completion(userStatus)
                }
            }
        }
    }
    
    // フォローフォロワーステータスをfetch
    func fetchUserStats(){
        UserService.shared.fetchUserStats(uid: user.uid) { (stats) in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    // unblock時の処理をまとめたもの
    func afterUnblockProcess(){
        fetchLogs()
        fetchLikeLogs()
        fetchSpots()
        fetchUserStats()
    }
    
    
    
    
    // MARK: - Selectors
    
    @objc func handleRefresh(){
        if user.userStatus == .blocking{
            whenBlockRefresh()
        }else{
            switch selectedFilter {
            case .logs:
                fetchLogs()
                fetchUserStats()
            case .locations:
                fetchSpots()
                fetchUserStats()
            case .likeLogs:
                fetchLikeLogs()
                fetchUserStats()
            }
        }
    }
    
    @objc func handleActionSheetLaunch(){
        // rightBarButtonは(!isCurrentUser)のみ追加されるので分岐の必要性なし
        showActionSheet()
    }
    
    // MARK: - Helpers
    
    func configureCollectionView(){
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // cell等を登録
        self.collectionView!.register(LogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(ProfileHeader.self, forCellWithReuseIdentifier: headerIdentifier)
        self.collectionView.register(ProfileFilterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: fileterViewIdentifier)
        self.collectionView.register(SpotCell.self, forCellWithReuseIdentifier: spotCellIdentifier)
        self.collectionView.register(UserBlockView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: blockUserViewIdentifier)
        
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.sectionHeadersPinToVisibleBounds = true
    }
    
    func configureNavigationBar(){
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .systemGroupedBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.title = user.username
        
        if !user.isCurrentUser{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle.fill"), style: .plain, target: self, action: #selector(handleActionSheetLaunch))
        }
    }
    
    fileprivate func showActionSheet(){
        actionSheetLauncher = ActionSheetLauncher(user: user, isLog: false, isProfile: true)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}

// MARK: UICollectionViewDataSource

extension ProfileController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return currentDataSource.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
            cell.user = user
            cell.delegate = self
            let logCount = String(logs.count) 
            cell.logCountButton.setTitle(logCount, for: .normal)
            return cell
        default:
            switch selectedFilter{
            case .locations:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: spotCellIdentifier, for: indexPath) as! SpotCell
                cell.spot = currentDataSource[indexPath.row] as? Spot
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LogCell
                cell.log = currentDataSource[indexPath.row] as? Log
                cell.delegate = self
                return cell
            }
        }
    }
}

// MARK: UICollectionViewDelegate

extension ProfileController{
    
    // headerにfilterViewを設定
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: fileterViewIdentifier, for: indexPath) as! ProfileFilterView
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        default:
            switch selectedFilter {
            case .locations:
                let spot = spots[indexPath.item] 
                let controller = SpotController(spot: spot)
                navigationController?.pushViewController(controller, animated: true)
            default:
                guard let log = currentDataSource[indexPath.item] as? Log else { return }
                let controller = LogController(log: log)
                controller.delegate = self
                controller.indexValue = indexPath.item
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    // headerのsizeを決める
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 0, height: 0)
        default:
            let height: CGFloat = 50
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let height:CGFloat = user.bio != nil ? 260 : 220
            return CGSize(width: view.frame.width, height: height)
        default:
            var height: CGFloat = 200
            if selectedFilter == .locations{
                height = 120
            }
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate{
    func handleFollowingButtonTapped() {
        let currentUserUid = user.uid
        let controller = UserListController(option: .followingUser, currentUserUid: currentUserUid)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleFollowedButtonTapped() {
        let currentUserUid = user.uid
        let controller = UserListController(option: .followedUser, currentUserUid: currentUserUid)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleEditProfile(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return
        }
        
        // 相手をフォローしている時
        if user.userStatus == .following{
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                if let err = err {
                    print("DEBUG: error is \(err.localizedDescription)")
                    return
                }
                self.user.userStatus = .notFollowing
                self.fetchUserStats()
                self.collectionView.reloadData()
            }
        }else if user.userStatus == .notFollowing{
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                if let err = err {
                    print("DEBUG: error is \(err.localizedDescription)")
                    return
                }
                self.user.userStatus = .following
                self.fetchUserStats()
            }
        }else if user.userStatus == .blocking{
            // ブロックを解除する処理を追加する
            UserService.shared.unblockUser(unblockUid: user.uid) { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                
                self.user.userStatus = .notFollowing
                // 諸々のデータをfetchする
                self.afterUnblockProcess()
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - ProfileFilterViewDelegate

extension ProfileController: ProfileFilterViewDelegate{
    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        selectedFilter = filter
        collectionView.reloadData()
    }
}

// MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate{
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
        self.collectionView.reloadData()
    }
    
    func handleLogout() {
        showLoader(true, withText: "ログアウト中")
        do {
            try Auth.auth().signOut()
            
            self.showLoader(false)
            
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }catch let error{
            
            self.showLoader(false)
            
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}

// MARK: - LogCellDelegate

extension ProfileController: LogCellDelegate{
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
        if self.user.uid == user.uid {
            return
        }
        let controller = ProfileController(user: user)
        controller.checkUserStatus { (status) in
            controller.user.userStatus = status!
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - ActionSheetLaucherDelegate

extension ProfileController: ActionSheetLauncherDelegate{
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(_):
            let uid = user.uid
            UserService.shared.followUser(uid: uid) { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                self.user.userStatus = .following
                self.fetchUserStats()
            }
        case .unfollow(_):
            let uid = user.uid
            UserService.shared.unfollowUser(uid: uid) { (error, ref) in
                if let error = error {
                    print("DEBUG: error is \(error.localizedDescription)")
                    return
                }
                self.user.userStatus = .notFollowing
                self.fetchUserStats()
            }
        case .report:
            let uid = user.uid
            UserService.shared.reportUser(reportUid: uid) { (err, ref) in
                if let err = err{
                    print("DEBUG: error is \(err.localizedDescription)")
                    return
                }
                print("DEBUG: report successfully")
            }
        case .delete:
            return
        case .block(_):
            let blockUid = user.uid
            
            UserService.shared.blockUser(blockUid: blockUid) { (err, ref) in
                if let err = err{
                    print("DEBUG: error is \(err.localizedDescription)")
                    return
                }
                
                self.user.isBlocking = true

                // 当該ユーザーをfollowしていた際の処理
                if self.user.userStatus == .following{
                    UserService.shared.unfollowUser(uid: blockUid) { (error, ref) in
                        if let error = error {
                            print("DEBUG: error is \(error.localizedDescription)")
                            return
                        }
                        self.user.userStatus = .blocking
                        self.fetchUserStats()
                        
                        // 表示されていたlogs, likeLogs, spotsを消す
                        self.logs.removeAll()
                        self.likeLogs.removeAll()
                        self.spots.removeAll()
                    }
                }
            }
        case .unblock(_):
            let unblockUid = user.uid
            
            UserService.shared.unblockUser(unblockUid: unblockUid) { (err, ref) in
                if let err = err{
                    print("DEBUG: error is \(err.localizedDescription)")
                    return
                }
                
                self.user.userStatus = .notFollowing
                self.afterUnblockProcess()
                self.collectionView.reloadData()
            }
        }
    }
}


// MARK: - LogControllerDelegate

extension ProfileController: LogControllerDelegate{
    func controller(_ controller: LogController) {
        logs.remove(at: controller.indexValue!)
        controller.navigationController?.popViewController(animated: true)
        self.collectionView.reloadData()
    }
}
