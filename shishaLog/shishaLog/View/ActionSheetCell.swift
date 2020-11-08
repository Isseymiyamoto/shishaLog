//
//  ActionSheetCell.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/25.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class ActionSheetCell: UITableViewCell{
    
    // MARK: - Properties
    
    var isLog: Bool?
    var isProfile: Bool?
    
    var option: ActionSheetOptions? {
        didSet{ configure() }
    }
    
    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .gray
        iv.setDimensions(width: 24, height: 24)
        iv.image = UIImage(named: "shsihaLog")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "test option"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: leftAnchor, paddingLeft: 16)
        optionImageView.setDimensions(width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor, right: rightAnchor, paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(){
        
        guard let isLog = isLog else { return }
        guard let isProfile = isProfile else { return }
        if isLog{
            titleLabel.text = option?.descriptionForLog
        }else{
            if isProfile{
                titleLabel.text = option?.descriptionForProfile
            }else{
                titleLabel.text = option?.descriptionforSpot
            }
        }
        
        switch option {
        case .some(.follow(_)): optionImageView.image = UIImage(systemName: "person.badge.plus")
        case .some(.unfollow(_)): optionImageView.image = UIImage(systemName: "person.badge.minus")
        case .some(.report): return
        case .some(.delete): optionImageView.image = UIImage(systemName: "trash")
        case .some(.block(_)): optionImageView.image = UIImage(systemName: "hand.raised.slash")
        case .none: return
        case .some(.unblock(_)): optionImageView.image = UIImage(systemName: "hand.raised")
        }
    }
    
}
