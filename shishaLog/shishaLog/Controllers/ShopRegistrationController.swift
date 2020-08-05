//
//  ShopRegistrationController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

protocol ShopRegistrationProtocol {
    func checkFormStatus()
}


class ShopRegistrationController: UIViewController{
    
    // MARK: - Properties
    
    private var viewModel = ShopRegistrationViewModel()
    
    private let titleImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "shishaLog_theme"))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "シーシャ情報を登録"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
   
    private let imagePicker = UIImagePickerController()
    private var shopImage: UIImage? {
        didSet{ checkFormStatus() }
    }
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(handleAddShopPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var shopNameContainerView: UIView = {
        let image = UIImage(systemName: "house")
        let view = Utilities().inputContainerView(withImage: image!, textField: shopNameTextField, withColor: .systemGray)
        return view
    }()
    
    private lazy var shopAddressContainerView: UIView = {
        let image = UIImage(systemName: "mappin.and.ellipse")
        let view = Utilities().inputContainerView(withImage: image!, textField: shopAddressTextField, withColor: .systemGray)
        return view
    }()
    
    private let shopNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "ショップ名", withColor: .black, attributedTextColor: .systemGray)
        return tf
    }()
    
    private let shopAddressTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "住所", withColor: .black, attributedTextColor: .systemGray)
        return tf
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登録する", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .shishaColor
        button.backgroundColor = .systemGray
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
 
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    func registerShop(){
        guard let shopName = shopNameTextField.text else { return }
        guard let shopAddress = shopAddressTextField.text else { return }
        guard shopImage != nil else { return }
        
        let credential = ShopCredentials(shopName: shopName, shopAddress: shopAddress, shopImage: shopImage!)
        
        ShopService.shared.registerShop(credentials: credential) { (error, ref) in
            if let error = error {
                print("DEBUG: failed to register shop with error \(error.localizedDescription)")
                return
            }
            // 後でprotocol設定して、choiceSpotControllerから操作も考える
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAddShopPhoto(){
        present(imagePicker, animated: true)
    }
    
    @objc func handleRegistration(){
        registerShop()
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == shopNameTextField{
            viewModel.shopName = sender.text
        }else{
            viewModel.shopAddress = sender.text
        }
        
        checkFormStatus()
    }
    
   
    
    
    // MARK: - Helpers
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.titleView = titleImage
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: titleLabel.bottomAnchor , paddingTop: 32)
        plusPhotoButton.setDimensions(width: 120, height: 120)
        plusPhotoButton.layer.cornerRadius = 120 / 2
        plusPhotoButton.layer.borderColor = UIColor.systemGray.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        let stack = UIStackView(arrangedSubviews: [shopNameContainerView, shopAddressContainerView, registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.centerX(inView: view, topAnchor: plusPhotoButton.bottomAnchor, paddingTop: 32)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        
        shopNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        shopAddressTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - UIImagePickeDelegate

extension ShopRegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let shopImage = info[.editedImage] as? UIImage else { return }
        self.shopImage = shopImage
        
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderWidth = 2
        
        self.plusPhotoButton.setImage(shopImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ShopRegistrationProtocol

extension ShopRegistrationController: ShopRegistrationProtocol{
    
    func checkFormStatus() {
        viewModel.shopImage = shopImage
        
        if viewModel.formIsValid{
            registrationButton.isEnabled = true
            registrationButton.backgroundColor = .shishaColor
        }else{
            registrationButton.isEnabled = false
            registrationButton.backgroundColor = .systemGray
        }
    }
}

