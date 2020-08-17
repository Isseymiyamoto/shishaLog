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
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check In", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .shishaColor
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(handleUploadSpot), for: .touchUpInside)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("キャンセル", for: .normal)
//        button.setTitleColor(.shishaColor, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.shishaColor.cgColor
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, actionButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
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
        configureNotificationObservers()
    }
    
    // MARK: - API
    
    func uploadSpot(){
        guard let comment = commentTextView.text else { return }
        
        showLoader(true, withText: "送信中")
        
        SpotService.shared.uploadSpot(shopID: shop.shopID, comment: comment) { (error, ref) in
            if error != nil {
                self.showError(withMessage: "スポット")
                return
            }
            
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleUploadSpot(){
        uploadSpot()
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
//        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0) //←
        UIView.animate(withDuration: duration, animations: {
            self.buttonStack.frame.origin.y -= keyboardSize.height
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        
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
        
        view.addSubview(buttonStack)
        buttonStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                           paddingLeft: 16, paddingBottom: 12, paddingRight: 16, height: 32)
        
        
        
    }
    
    func configureNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}


