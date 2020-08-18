//
//  NoContentsView.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/08/18.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class NoContentsView: UIView {
    
    // MARK: - Properties
    
    private var option: NoContentsOptions
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let promotionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let promotionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.setDimensions(width: 200, height: 36)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    init(option: NoContentsOptions) {
        self.option = option
        super.init(frame: .zero)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, promotionLabel])
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .leading
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 32, paddingLeft: 16)
        
        addSubview(promotionButton)
        promotionButton.anchor(top: stack.bottomAnchor, left: leftAnchor, paddingTop: 32, paddingLeft: 16)
        promotionButton.layer.cornerRadius = 4
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Helpers
    
    func configure(){
        titleLabel.text = option.titleDescription
        promotionLabel.text = option.promotionText
        promotionButton.setTitle(option.buttonText, for: .normal)
    }
    
    
}

// MARK: - NoContentsOptions

enum NoContentsOptions: Int, CaseIterable {
    
    case logs
    case spots
    
    var titleDescription: String{
        switch self {
        case .logs: return "表示するログがありません"
        case .spots: return "表示するスポットがありません"
        }
    }
    
    var promotionText: String{
        switch self {
        case .logs: return "初めての投稿を行ってみましょう"
        case .spots: return "初めてのチェックインを行ってみましょう"
        }
    }
    
    var buttonText: String{
        switch self {
        case .logs: return "投稿する"
        case .spots: return "チェックイン"
        }
    }
}
