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
        
        self.collectionView!.register(LogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(LogHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: logHeaderIdentifier)
        
        navigationItem.title = "スレッド"
        
        
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
    func handleProfileImageTapped(_ jumpToUser: User) {
        
        let controller = ProfileController(user: jumpToUser)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}





