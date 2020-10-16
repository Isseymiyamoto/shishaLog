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
    private var viewModel = RegistrationViewModel()
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputContainerView(withImage: image!, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image!, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputContainerView(withImage: image!, textField: fullnameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputContainerView(withImage: image!, textField: usernameTextField)
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
    
    private let fullnameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "お名前", withColor: .white)
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "ユーザー名", withColor: .white)
        return tf
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("もう既にアカウントをお持ちですか?", "  ログイン")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登録する", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleShowUserPolicy), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }

    
    // MARK: - API
    
    
    
    // MARK: - Selectors
    
    @objc func handleAddProfilePhoto(){
        // imagePickerを出現させる
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleShowUserPolicy(){
        guard profileImage != nil else { showNeedInputError(); return }
       
        let controller = UserPolicyController()
        controller.delegate = self
        present(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }else if sender == fullnameTextField{
            viewModel.fullname = sender.text
        }else if sender == usernameTextField{
            viewModel.username = sender.text
        }else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    
    
    // MARK: - Helpers
    func configureUI(){
        configureGradientLayer()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // logoImageを画面中心に配置(w150h150)
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 64)
        plusPhotoButton.setDimensions(width: 120, height: 120)
        plusPhotoButton.layer.cornerRadius = 120 / 2
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView, registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)

    }
    
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
    // 登録処理
    func handleRegistration(){
        guard let profileImage = profileImage else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        showLoader(true, withText: "登録中")
        
        AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
            if let error = error{
                self.showLoader(false)
                self.showError(error)
                return
            }
            
            self.showLoader(false)
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showNeedInputError(){
        let alert = UIAlertController(title: "エラー", message: "アイコンを登録してください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderWidth = 2
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UserPolicyControllerDelegate

extension RegistrationController: UserPolicyControllerDelegate{
    func handleBackRegister(_ UserPolicyView: UserPolicyController) {
        print("DEBUG: 反応あり in RegistrationController")
        UserPolicyView.dismiss(animated: true) {
            self.handleRegistration()
        }
    }
}

// MARK: - AuthenticationControllerProtocol

extension RegistrationController: AuthenticationControllerProtocol{
    func checkFormStatus(){
        if viewModel.formIsValid {
            registrationButton.isEnabled = true
            registrationButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
            registrationButton.isEnabled = false
            registrationButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
}
