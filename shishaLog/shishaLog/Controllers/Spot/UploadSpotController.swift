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
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("チェックイン", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 96, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.backgroundColor = .shishaColor
        button.addTarget(self, action: #selector(handleUploadSpot), for: .touchUpInside)
        return button
    }()
    
    private let spotTextView: UITextField = {
        let tv = UITextField()
        tv.placeholder = "タップ"
        
        return tv
    }()
    
    
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadSpot(){
        // firebaseに接続
        print("DEBUG: this is successfully good")
    }
    
    
    // MARK: - Helpers
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        // isTranslucent → ナビゲーションバーを透過にするかのフラグであり,ビューの開始位置を決めるフラグ
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(actionButton)
    }
    
}


