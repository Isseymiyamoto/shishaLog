//
//  PaddingTextField.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/08/05.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField{
    
    // MARK: - Properties
    
    var padding: CGPoint = CGPoint(x: 6.0, y: 0)
    
    // MARK: Internal Methods

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // テキストの内側に余白を設ける
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // 入力中のテキストの内側に余白を設ける
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        // プレースホルダーの内側に余白を設ける
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }
    
    
}
