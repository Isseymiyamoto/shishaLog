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
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "shishaLog_theme")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputContainerView(withImage: image!, textField: emailTextField, withColor: .white)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image!, textField: passwordTextField, withColor: .white)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Eメール", withColor: .white)
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "パスワード", withColor: .white)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ログイン", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("まだアカウントを持っていませんか?", "  登録する")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    
    // MARK: - API
    
    
    // MARK: - Selectors
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        showLoader(true, withText: "ログイン中")
        
        AuthService.shared.loginUser(withEmail: email, password: password) { (result, error) in
            if let error = error{
                self.showLoader(false)
                print("DEBUG: Fail to loging \(error.localizedDescription)")
                return
            }
            
            self.showLoader(false)
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI(){
//        view.backgroundColor = .shishaColor
        configureGradientLayer()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        // logoImageを画面中心に配置(w150h150)
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 64)
        logoImageView.setDimensions(width: 120, height: 120)
        logoImageView.layer.cornerRadius = 120 / 2
        
        // stackViewでmail & passwordのtextField & login Buttonを配置
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)

        // registrationに遷移するぶbuttonを配置
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}



