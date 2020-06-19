//
//  ProfileHeader.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/17.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionReusableView{
    
    // MARK: - Properties
    
    var user: User? {
        didSet{ configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.shishaColor.cgColor
        iv.layer.borderWidth = 4
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80 / 2
        return iv
    }()
    
    private lazy var logCountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("30", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private lazy var followingCountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("290", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private lazy var followedCountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("3000", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let logCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Logs"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.text = "フォロー"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let followedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "フォロワー"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than one line for test purposes"
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.shishaColor.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .shishaColor
        button.addTarget(self, action: #selector(handleEdidFollowProfile), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGroupedBackground
        
        // info系のstack
        let logCountStack = makeStackView(button: logCountButton, label: logCountLabel)
        let followingCountStack = makeStackView(button: followingCountButton, label: followingCountLabel)
        let followedCountStack = makeStackView(button: followedCountButton, label: followedCountLabel)
        logCountStack.backgroundColor = .red
        followingCountStack.backgroundColor = .blue
        followedCountStack.backgroundColor = .cyan
        
        let infoStack = UIStackView(arrangedSubviews: [logCountStack, followingCountStack, followedCountStack])
        infoStack.axis = .horizontal
        infoStack.alignment = .center
        infoStack.distribution = .fillEqually
        
        addSubview(profileImageView)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 32, paddingLeft: 16)
        
        addSubview(infoStack)
        infoStack.centerY(inView: profileImageView)
        infoStack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 32)
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        addSubview(bioLabel)
        bioLabel.anchor(top: fullnameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: bioLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16)
        editProfileFollowButton.setDimensions(width: self.frame.width - 32, height: 36)
        editProfileFollowButton.layer.cornerRadius = 6
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal(){
        
    }
    
    // 自分のprofileか他者かによって挙動を変える
    @objc func handleEdidFollowProfile(){
        
    }
    
    
    // MARK: - Helpers
    
    fileprivate func makeStackView(button: UIButton, label: UILabel) -> UIStackView{
        let stack = UIStackView(arrangedSubviews: [button, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.setDimensions(width: 160, height: 40)
        return stack
    }
    
    func configure(){
        profileImageView.sd_setImage(with: user?.profileImageUrl, completed: nil)
        fullnameLabel.text = user?.fullname
    }
    
    
    
}