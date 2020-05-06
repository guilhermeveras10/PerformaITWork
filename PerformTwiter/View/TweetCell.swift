//
//  TweetCell.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 28/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReply(_ cell: TweetCell)
    func handleLike(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    //MARK: - Propeties
    
    var tweet: Tweet? {
        didSet{config()}
    }
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let replyLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.text = "Compartilha do @andre"
        return lbl
    }()
    
    private let captionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.text = "algum text"
        return lbl
    }()
    
    private lazy var commentBtn: UIButton = {
        let btn = Utilities().TweetsCellBtn(image: "comment")
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    
    private lazy var retweetBtn: UIButton = {
        let btn = Utilities().TweetsCellBtn(image: "retweet")
        btn.addTarget(self, action: #selector(handleRetweet), for: .touchUpInside)
        return btn
    }()
    
    private lazy var likeBtn: UIButton = {
        let btn = Utilities().TweetsCellBtn(image: "like")
        btn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shareBtn: UIButton = {
        let btn = Utilities().TweetsCellBtn(image: "share")
        btn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return btn
    }()
    
    private let infoLabel = UILabel()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
                
        let stackText = UIStackView(arrangedSubviews: [infoLabel,captionLabel])
        stackText.axis = .vertical
        stackText.spacing = 4
        stackText.distribution = .fillProportionally
        
        let imageStack = UIStackView(arrangedSubviews: [profileImageView,stackText])
        imageStack.spacing = 12
        imageStack.alignment = .leading
        imageStack.distribution = .fillProportionally
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 12)
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.text = "gui"
        
        let underline = UIView()
        underline.backgroundColor = .systemGroupedBackground
        addSubview(underline)
        underline.anchor(left: leftAnchor, bottom: bottomAnchor,right: rightAnchor , height: 1)
        
        let stackBtn = UIStackView(arrangedSubviews: [commentBtn,retweetBtn,likeBtn,shareBtn])
        stackBtn.axis = .horizontal
        stackBtn.spacing = 72
        
        addSubview(stackBtn)
        stackBtn.centerX(inView: self)
        stackBtn.anchor(bottom:  bottomAnchor, paddingBottom: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleComment() {
        delegate?.handleReply(self)
        
    }
    
    @objc func handleRetweet() {
        
    }
    
    @objc func handleLike() {
        delegate?.handleLike(self)
    }
    
    @objc func handleShare() {
        
    }
    
    @objc func handleProfileTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    //MARK: - Helpers
    
    func config() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        infoLabel.attributedText = viewModel.userInfoText
        likeBtn.tintColor = viewModel.likeBtnTint
        likeBtn.setImage(viewModel.likeBtnImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
}
