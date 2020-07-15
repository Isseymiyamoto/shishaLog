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
        button.setTitle("Logする", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .shishaColor
        button.addTarget(self, action: #selector(handleUploadLog), for: .touchUpInside)
        return button
    }()
    
//    private let spotTextField: UITextField = {
//        let tf = Utilities().textField(withPlaceholder: "spotを教えてください")
//        tf.textColor = .black
//        tf.font = UIFont.systemFont(ofSize: 16)
//        return tf
//    }()
    
    private let spotTextView: UITextView = {
        let tv = CaptionTextView(withPlaceholder: "spotを書き留める")
        return tv
    }()
    
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
        
    }
    
    // MARK: - API
    
    func uploadLog(location: String, mix: String, feeling: String, completion: @escaping((Error?, DatabaseReference) -> Void)){
        LogService.shared.uploadLog(location: location, mix: mix, feeling: feeling, completion: completion)
    }
    
    
    
    // MARK: - Selectors
    
    @objc func handleUploadLog(){
        guard let location = spotTextView.text else { return }
        guard let mix = mixTextView.text else { return }
        guard let feeling = feelTextView.text else { return }
        
        uploadLog(location: location, mix: mix, feeling: feeling) { (error, ref) in
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
    
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        configureNavigationBar()
        
        let stack = UIStackView(arrangedSubviews: [spotLabel, spotTextView, mixLabel, mixTextView, feelLabel, feelTextView])
        stack.spacing = 12
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(logButton)
        logButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        logButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        logButton.layer.cornerRadius = 48 / 2
    }
    
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        // isTranslucent → ナビゲーションバーを透過にするかのフラグであり,ビューの開始位置を決めるフラグ
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }

    

}
