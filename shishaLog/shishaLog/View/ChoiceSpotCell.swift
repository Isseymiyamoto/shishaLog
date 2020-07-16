//
//  ChoiceSpotCell.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/15.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

class ChoiceSpotCell: UITableViewCell {

    // MARK: - Properties
    
    var shop: Shop? {
        didSet{ configureUI() }
    }
    
    private let shopImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .shishaColor
        
        // test 的に
        iv.image = UIImage(named: "shisha")
        return iv
    }()
    
    private let shopNameLabel: UILabel = {
        let label = UILabel()
        // test的に
        label.text = "Soi 61"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "中野区弥生町12-28-1"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(shopImageView)
        shopImageView.centerY(inView: self)
        shopImageView.anchor(left: leftAnchor, paddingLeft: 16)

        let stack = UIStackView(arrangedSubviews: [shopNameLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading

        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: shopImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
    }
    
    func configureUI(){
        guard let shop = shop else { return }
        
        shopImageView.sd_setImage(with: shop.shopImageUrl, completed: nil)
        shopNameLabel.text = shop.shopName
        addressLabel.text = shop.address
    }
    
//    init(shop: Shop) {
//        self.shop = shop
//        super.init(style: .default, reuseIdentifier: "ChoiceCell")
//
//        addSubview(shopImageView)
//        shopImageView.centerY(inView: self)
//        shopImageView.anchor(left: leftAnchor, paddingLeft: 16)
//
//        let stack = UIStackView(arrangedSubviews: [shopNameLabel, addressLabel])
//        stack.axis = .vertical
//        stack.spacing = 2
//        stack.alignment = .leading
//
//        addSubview(stack)
//        stack.centerY(inView: self)
//        stack.anchor(left: shopImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
