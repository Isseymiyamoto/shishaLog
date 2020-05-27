//
//  RegistrationController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController{
    
    // MARK: - Properties
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("test title", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .twitterBlue
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
    }
    
    
    // MARK: - API
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        
        view.addSubview(actionButton)
        actionButton.center(inView: view)
        actionButton.setDimensions(width: 320, height: 48)
        actionButton.layer.cornerRadius = 48 / 2
    }
    
}
