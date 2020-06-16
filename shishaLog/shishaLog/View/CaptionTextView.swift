//
//  CaptionTextView.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class CaptionTextView: UITextView{
    
    // MARK: - Properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(withPlaceholder placeholder: String){
        self.placeholderLabel.text = placeholder
        super.init(frame: .zero, textContainer: .none)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.75
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleTextInputChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}
