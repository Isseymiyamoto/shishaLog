//
//  LoginController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/05/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        
    }
    

    
    // MARK: - API
    
    
    // MARK: - Helpers
    
    func configureUI(){
        // logoImageを画面中心に配置(w150h150)
        
        // stackViewでmail & passwordのtextFieldを配置
        
        // registrationに遷移するぶbuttonを配置
    }
    
    

    

}
