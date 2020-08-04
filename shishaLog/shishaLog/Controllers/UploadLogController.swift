//
//  UploadLogController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/08.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit
import Firebase

class UploadLogController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    private var shop: Shop?
    
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
        button.setTitle("投稿する", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(handleUploadLog), for: .touchUpInside)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("キャンセル", for: .normal)
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
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, actionButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let spotLabel: UILabel = {
        let label = UILabel()
        label.text = "SPOT"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let mixLabel: UILabel = {
        let label = UILabel()
        label.text = "MIX"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let feelLabel: UILabel = {
        let label = UILabel()
        label.text = "FEEL"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let logButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("投稿する", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .shishaColor
        button.addTarget(self, action: #selector(handleUploadLog), for: .touchUpInside)
        return button
    }()
    
    
    // test
    private lazy var spotSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleSpotSearchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let spotTextField: UITextField = {
        let tf = UITextField()
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.borderWidth = 0.75
        tf.placeholder = " spotを書き留める"
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return tf
    }()
    
//    private let spotTextView: UITextView = {
//        let tv = CaptionTextView(withPlaceholder: "spotを書き留める")
//        return tv
//    }()
    
    private let mixTextView: UITextView = {
        let tv = CaptionTextView(withPlaceholder: "フレーバーを書き留める")
        return tv
    }()
    
    private let feelTextView: UITextView = {
        let tv = CaptionTextView(withPlaceholder: "感動を表現する")
        return tv
    }()
    
    // MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
//        configureNotificationObservers()
    }
    
    // MARK: - API
    
    func uploadLog(location: String, mix: String, feeling: String, shopID: String? = nil, completion: @escaping((Error?, DatabaseReference) -> Void)){
        LogService.shared.uploadLog(location: location, mix: mix, feeling: feeling, shopID: shopID, completion: completion)
    }
    
    
    
    // MARK: - Selectors
    
    @objc func handleSpotSearchButtonTapped(){
        let controller = ChoiceSpotController(user: user, option: .fromUploadLog)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleUploadLog(){
        guard let location = spotTextField.text else { return }
        guard let mix = mixTextView.text else { return }
        guard let feeling = feelTextView.text else { return }
        
        uploadLog(location: location, mix: mix, feeling: feeling, shopID: <#String?#>) { (error, ref) in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: successfully uploaded your log")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
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
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        
        let stack = UIStackView(arrangedSubviews: [spotLabel, spotTextField, mixLabel, mixTextView, feelLabel, feelTextView])
        stack.spacing = 12
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(buttonStack)
        buttonStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                           paddingLeft: 16, paddingBottom: 12, paddingRight: 16, height: 32)
        
        view.addSubview(spotSearchButton)
        spotSearchButton.centerY(inView: spotTextField)
        spotSearchButton.anchor(right: spotTextField.rightAnchor, paddingRight: 16)
    }
    
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        // isTranslucent → ナビゲーションバーを透過にするかのフラグであり,ビューの開始位置を決めるフラグ
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        navigationItem.title = "新規ログ"
    }
    
    func configureNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - ChoiceSpotControllerDelegate

extension UploadLogController: ChoiceSpotControllerDelegate{
    func controller(_ controller: ChoiceSpotController, shop: Shop) {
        controller.navigationController?.popViewController(animated: true)
        self.shop = shop
        spotTextField.text = shop.shopName
    }
}
