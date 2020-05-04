//
//  TweetViewModel.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 28/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

struct TweetViewModel {
    
    let tweet: Tweet
    let user: User
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:m  a  dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetAtribbutedText: NSAttributedString? {
        return atribbutedString(withValue: tweet.retweetCount, text: "Compartilhamentos")
    }
    
    var likesAtribbutedText: NSAttributedString? {
        return atribbutedString(withValue: tweet.likes, text: "Likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: "@\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: "   📆 \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var likeBtnTint: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeBtnImage: UIImage {
        let imageName = tweet.didLike ? "like_filled":"like"
        return UIImage(named: imageName)!
    }
    
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func atribbutedString(withValue value: Int, text: String) -> NSAttributedString {
        let atribbutedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atribbutedTitle.append(NSAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return atribbutedTitle
    }
    
    func size(width: CGFloat) -> CGSize {
        let measureLabel = UILabel()
        measureLabel.text = tweet.caption
        measureLabel.numberOfLines = 0
        measureLabel.lineBreakMode = .byWordWrapping
        measureLabel.translatesAutoresizingMaskIntoConstraints = false
        measureLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
