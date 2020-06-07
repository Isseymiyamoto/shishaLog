//
//  LogCell.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/05.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class LogCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Soi 61"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let mixLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "レモンドロップ4g\nレモン2g\nバニラ2g"
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .shishaColor
        return label
    }()
    
    private let feelingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "ナハラと豚のレモン\n酸っぱい甘く無い\nそうじゃ無い感"
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
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped(){
        
    }
    
    // MARK: - Helpers
    
    func configureUI(){

        let rightSideStack = UIStackView(arrangedSubviews: [infoLabel, locationLabel, mixLabel, feelingLabel])
        rightSideStack.axis = .vertical
        rightSideStack.spacing = 12
        rightSideStack.distribution = .fillProportionally
        rightSideStack.alignment = .fill
        
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, rightSideStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
        infoLabel.attributedText = userInfoText
    }
}
