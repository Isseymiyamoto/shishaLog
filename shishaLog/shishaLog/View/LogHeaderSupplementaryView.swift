//
//  LogHeader.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/28.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

protocol LogHeaderDelegate: class {
    func handleProfileImageTapped(_ jumpToUser: User)
    func handleLikeButtonTapped(_ header: LogHeaderSupplementaryView)
    func showActionSheet()
    func handleLikesLabelTapped()
    func handleLocationLabelTapped(shop: Shop)
}

class LogHeaderSupplementaryView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: LogHeaderDelegate?
    
    var log: Log? {
        didSet { configure() }
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
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .systemBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLocationLabelTapped))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let mixTextView: UITextView = {
        let tv = UITextView()
        tv.text = "レモンドロップ4g\nレモン2g\nバニラ2g"
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .black
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .shishaColor
        tv.layer.cornerRadius = 4
        tv.backgroundColor?.withAlphaComponent(0.1)
        return tv
    }()
    
    private let feelingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "ナハラと豚のレモン\n酸っぱい甘く無い\nそうじゃ無い感"
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
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bm"), for: .normal)
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        button.setDimensions(width: 20, height: 20)
        button.tintColor = UIColor.rgb(red: 232, green: 75, blue: 110)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLikeLabelTapped))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        view.addSubview(likesLabel)
        likesLabel.centerY(inView: view)
        likesLabel.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                        right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        imageCaptionStack.spacing = 12
        
        addSubview(imageCaptionStack)
        imageCaptionStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        let captionLabelStack = UIStackView(arrangedSubviews: [locationLabel, mixTextView, feelingLabel])
        captionLabelStack.axis = .vertical
        captionLabelStack.spacing = 12
        captionLabelStack.distribution = .fillProportionally
        captionLabelStack.alignment = .fill
        
        addSubview(captionLabelStack)
        captionLabelStack.anchor(top: imageCaptionStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabelStack.bottomAnchor, left: leftAnchor, paddingTop: 20,
                         paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: imageCaptionStack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 16)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor,
                         right: rightAnchor, paddingTop: 12, height: 40)
        
        addSubview(likeButton)
        likeButton.anchor(bottom: statsView.topAnchor, right: rightAnchor, paddingBottom: 12, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped(){
        guard let user = log?.user else { return }
        delegate?.handleProfileImageTapped(user)
    }
    
    @objc func handleLikeButtonTapped(){
        delegate?.handleLikeButtonTapped(self)
    }
    
    @objc func handleActionSheetShow(){
        delegate?.showActionSheet()
    }
    
    @objc func handleLikeLabelTapped(){
        print("DEBUG: これはきてますねえ")
        guard let likes = log?.likes else { return }
        if likes == 0{
            print("DEBUG: likes is 0")
            return
        }
        delegate?.handleLikesLabelTapped()
    }
    
    @objc func handleLocationLabelTapped(){
        guard let shop = log?.shop else { return }
        delegate?.handleLocationLabelTapped(shop: shop)
    }
    
    // MARK: - Helpers
        
    func configure(){
        guard let log = log else { return }
        let viewModel = LogViewModel(log: log)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        fullnameLabel.text = log.user.fullname
        usernameLabel.text = viewModel.usernameText
        
        locationLabel.text = viewModel.locationLabelText
        locationLabel.textColor = viewModel.locationLabelTextColor
        
        mixTextView.text = log.mix
        feelingLabel.text = log.feeling
        
        dateLabel.text = viewModel.headerTimeStamp
        
        likesLabel.attributedText = viewModel.likesAttributedString
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
    }
}
