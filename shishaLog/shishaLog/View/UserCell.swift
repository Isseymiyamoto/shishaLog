//
//  UserCell.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/17.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - Properties
    
    var user: User? {
        didSet{
            configureUI()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .shishaColor
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "username"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "fullname"
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let nameStack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        nameStack.axis = .vertical
        nameStack.alignment = .leading
        nameStack.spacing = 2
        nameStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, nameStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        guard let user = user else { return }
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
    }
    

}
