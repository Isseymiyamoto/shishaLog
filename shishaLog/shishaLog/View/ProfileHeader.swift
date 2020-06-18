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
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var logCountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("30", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private lazy var followingCountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("290", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private lazy var followedCountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("3000", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
        label.text = "フォロワー"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let followedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "フォロー中"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than one line for test purposes"
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.shishaColor.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.shishaColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEdidFollowProfile), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // info系のstack
        let logCountStack = makeStackView(button: logCountButton, label: logCountLabel)
        let followingCountStack = makeStackView(button: followedCountButton, label: followedCountLabel)
        let followedCountStack = makeStackView(button: followedCountButton, label: followedCountLabel)
        
        let infoStack = UIStackView(arrangedSubviews: [profileImageView, logCountStack, followingCountStack, followedCountStack])
        infoStack.axis = .horizontal
        infoStack.spacing = 12
        infoStack.alignment = .center
        infoStack.distribution = .fillProportionally
        
        addSubview(infoStack)
        infoStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16)
        
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
        stack.spacing = 4
        return stack
    }
    
    func configure(){
        profileImageView.sd_setImage(with: user?.profileImageUrl, completed: nil)
        fullnameLabel.text = user?.fullname
    }
    
    
    
}
