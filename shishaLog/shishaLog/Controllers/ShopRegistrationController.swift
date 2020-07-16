//
//  ShopRegistrationController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class ShopRegistrationController: UIViewController{
    
    // MARK: - Properties
    
    private let titleImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "pencil.circle"))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 32, height: 32)
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
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(handleAddShopPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var shopNameContainerView: UIView = {
        let image = UIImage(systemName: "")
        let view = Utilities().inputContainerView(withImage: image!, textField: shopNameTextField)
        return view
    }()
    
    private lazy var shopAddressContainerView: UIView = {
        let image = UIImage(systemName: "")
        let view = Utilities().inputContainerView(withImage: image!, textField: shopAddressTextField)
        return view
    }()
    
    private let shopAddressTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "住所")
        return tf
    }()
    
    private let shopNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "ショップ名")
        return tf
    }()
 
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAddShopPhoto(){
        
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
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: titleLabel.bottomAnchor , paddingTop: 32)
        plusPhotoButton.setDimensions(width: 120, height: 120)
        plusPhotoButton.layer.cornerRadius = 120 / 2
        plusPhotoButton.layer.borderColor = UIColor.systemGray.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        let stack = UIStackView(arrangedSubviews: [shopNameContainerView, shopAddressContainerView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 32
        
        view.addSubview(stack)
        stack.centerX(inView: view, topAnchor: plusPhotoButton.bottomAnchor, paddingTop: 32)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        
     
    }
    
    
    
}
