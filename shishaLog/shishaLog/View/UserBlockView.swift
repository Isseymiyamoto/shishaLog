//
//  UserBlockView.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/10/27.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class UserBlockView: UICollectionReusableView{
    
    // MARK: - Properties
    
    private let blockUserName: String
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    init(userName: String) {
        self.blockUserName = userName
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        titleLabel.text = "@\(blockUserName)をブロックしています"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    
}
