//
//  UploadLogController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/08.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class UploadLogController: UIViewController {
    
    // MARK: - Properties
    
    private let somethingLabel: UILabel = {
        let label = UILabel()
        label.text = "something new"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logする", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 96, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.backgroundColor = .shishaColor
        button.addTarget(self, action: #selector(handleUploadLog), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    // MARK: - Lifecycle
    
//    init(user: User){
//        self.user = user
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    // MARK: - API
    
    
    
    
    // MARK: - Selectors
    
    @objc func handleUploadLog(){
        
        print("DEBUG: これでokやな")
        
        LogService.shared.uploadLog(location: "Soi 61", mix: "ラズベリー2g", feeling: "これがほんまにええんよな") { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("DEBUG: successfullu uploaded your log")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .systemGroupedBackground
        configureNavigationBar()
        
        view.addSubview(somethingLabel)
        somethingLabel.center(inView: view)
        
    }
    
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        // isTranslucent → ナビゲーションバーを透過にするかのフラグであり,ビューの開始位置を決めるフラグ
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }

    

}
