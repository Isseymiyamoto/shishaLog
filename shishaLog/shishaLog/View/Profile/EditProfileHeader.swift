//
//  EditProfileHeader.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/24.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChengeProfilePhoto()
}

class EditProfileHeader: UIView{
    
    // MARK: - Properties
    
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 96, height: 96)
        iv.layer.cornerRadius = 96 / 2
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.shishaColor.cgColor
        iv.layer.borderWidth = 3.0
        return iv
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("プロフィール写真を変更", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileImage), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User){
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .systemGroupedBackground
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleChangeProfileImage(){
        delegate?.didTapChengeProfilePhoto()
    }
    
    // MARK: - Helpers
    
    
    
    
}
