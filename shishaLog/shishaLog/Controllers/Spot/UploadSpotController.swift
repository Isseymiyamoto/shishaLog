//
//  UploadSpotController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class UploadSpotController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    private let shop: Shop
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "person.fill")
        return iv
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check In", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 96, height: 32)
//        button.layer.cornerRadius = 32 / 2
        button.backgroundColor = .shishaColor
        button.addTarget(self, action: #selector(handleUploadSpot), for: .touchUpInside)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("キャンセル", for: .normal)
        button.setTitleColor(.shishaColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.shishaColor.cgColor
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private let commentTextView: UITextField = {
        let tv = UITextField()
        tv.placeholder = "何してる？"
        return tv
    }()
    
    
    
    // MARK: - Lifecycle
    
    init(user: User, shop: Shop) {
        self.user = user
        self.shop = shop
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleUploadSpot(){
        // firebaseに接続
        print("DEBUG: this is successfully good")
    }
    
    
    // MARK: - Helpers
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
        navigationItem.title = shop.shopName
    }
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        view.addSubview(commentTextView)
        commentTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                               paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, actionButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        
        view.addSubview(buttonStack)
        buttonStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                           paddingLeft: 16, paddingBottom: 12, paddingRight: 16, height: 32)
        
        
        
    }
    
}


