//
//  UserPolicyController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/08/20.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class UserPolicyController: UIViewController{
    
    // MARK: - Properties
    
    private let userPolicyTextView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    private let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("同意する", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(handleAgreeUserPolicy), for: .touchUpInside)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
 
    // MARK: - Selectors
    
    @objc func handleAgreeUserPolicy(){
        // mainTabBarControllerに移動する
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configure(){
        userPolicyTextView.text = "これはテストです"
        
        view.addSubview(userPolicyTextView)
        
    }
    
    
    
}


