//
//  SpotHeader.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/29.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

protocol SpotHeaderDelegate: class {
    func handleProfileImageTapped(user: User)
    func showActionSheet()
}

class SpotHeader: UICollectionReusableView{
    
    // MARK: - Properties
    
    weak var delegate: SpotHeaderDelegate?
    
    var spot: Spot? {
        didSet{ configure() }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .shishaColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Peter Parker"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "spiderman"
        return label
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("@Soi61", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLocationTapped), for: .touchUpInside)
        return button
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "test comment"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "6:33 PM - 1/28/2020"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleActionSheetShow), for: .touchUpInside)
        button.setDimensions(width: 16, height: 16)
        return button
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped(){
        guard let user = spot?.user else { return }
        delegate?.handleProfileImageTapped(user: user)
    }
    
    @objc func handleLocationTapped(){
        
    }
    
    @objc func handleActionSheetShow(){
        delegate?.showActionSheet()
    }
    
    // MARK: - Helpers
    
    func configure(){
        
        guard let spot = spot else { return }
        let viewModel = SpotViewModel(spot: spot)
    }
}
