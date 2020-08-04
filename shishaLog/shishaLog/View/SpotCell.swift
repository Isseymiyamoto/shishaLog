//
//  SpotCell.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/29.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

protocol SpotCellDelegate: class {
    func handleProfileImageTapped(user: User)
    func handleLocationButtonTapped(shop: Shop)
}

class SpotCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: SpotCellDelegate?
    
    var spot: Spot? {
        didSet{ configure() }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person")
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .shishaColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    // 名前・ユーザー名・logを記録した時間からの経過を記載する
    private let infoLabel = UILabel()
    
    // infoLabelに入れるNSAttributedString
    private let userInfoText: NSAttributedString = {
        let title = NSMutableAttributedString(string: "ISSEY MIYAKE", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @i_bte6", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " 3分前", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("@Soi61", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLocationTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "test comment"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
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
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, locationButton, commentLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 8
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped(){
        // profileへ飛ばす
        guard let user = spot?.user else { return }
        delegate?.handleProfileImageTapped(user: user)
    }
    
    @objc func handleLocationTapped(){
        guard let shop = spot?.shop else { return }
        delegate?.handleLocationButtonTapped(shop: shop)
    }
    
    
    // MARK: - Helpers
    
    func configure(){
        
        guard let spot = spot else { return }
        let viewModel = SpotViewModel(spot: spot)
        
        infoLabel.attributedText = viewModel.userInfoText
        locationButton.setTitle(viewModel.shopName, for: .normal)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        commentLabel.text = viewModel.comment
    }
    
}
