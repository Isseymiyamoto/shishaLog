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
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        <#code#>
    }
    
    init(withPlaceholder placeholder: String){
        self.placeholderLabel.text = placeholder
        
        super.init(frame: .zero, textContainer: NSTextContainer?)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
