//
//  LogViewModel.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/07/25.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import Foundation
import UIKit

struct LogViewModel {
    
    // MARK: - Properties
    
    let log: Log
    let user: User
    
    var profileImageUrl: URL?{
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: log.timestamp, to: now) ?? "2m"
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var locationLabelText: String{
        return "@\(log.location)"
    }
    
    var locationLabelTextColor: UIColor{
        return log.shop != nil ? .systemBlue : .black
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ MM/dd/yyyy"
        return formatter.string(from: log.timestamp)
    }
    
    var userInfoText: NSAttributedString{
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)",
            attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " ・ \(timestamp)",
            attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return log.didLike ? UIColor.rgb(red: 232, green: 75, blue: 110) : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = log.didLike ? "bmpink" : "bm"
        return UIImage(named: imageName)!
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: log.likes, text: " いいね")
    }
    
    // MARK: - Lifecycle
    
    init(log: Log) {
        self.log = log
        self.user = log.user
    }
    
    
    // MARK: - Helpers
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                         NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    func size(withWidth width: CGFloat) -> CGSize{
        let cell = LogCell()
        cell.log = log
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.widthAnchor.constraint(equalToConstant: width).isActive = true
        cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: width, height: cell.bounds.height)
    }
}
