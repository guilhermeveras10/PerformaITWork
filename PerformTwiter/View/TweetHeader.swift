//
//  TweetHeader.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 29/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import ActiveLabel

protocol TweetHeaderDelegate: class {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    
    //MARK: - Propeties
    
    var tweet: Tweet? {
        didSet{config()}
    }
    
    weak var delegate: TweetHeaderDelegate?
    
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
    
    
    private let fullnameLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.boldSystemFont(ofSize: 14)
         lbl.text = "gui"
         return lbl
     }()
    
    private let usernameLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .lightGray
         lbl.text = "gui"
         return lbl
     }()
    
    private let captionLabel: ActiveLabel = {
        let lbl = ActiveLabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.text = "algum text"
        lbl.mentionColor = .blue
        lbl.hashtagColor = .blue
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.text = "algum text"
        return lbl
    }()
    
    private lazy var optionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .lightGray
        btn.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        btn.addTarget(self, action: #selector(handleActionSheet), for: .touchUpInside)
        return btn
    }()
    
    private lazy var retweetLabel: UILabel = {
        let lebel = UILabel()
        lebel.font = UIFont.systemFont(ofSize: 14)
        lebel.text = "2 compartilhamentos"
        return lebel
    }()
    
    private lazy var likeLabel: UILabel = {
        let lebel = UILabel()
        lebel.font = UIFont.systemFont(ofSize: 14)
        lebel.text = "0 Likes"
        return lebel
    }()
    
    private lazy var statsView: UIView = {
       let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left:  view.leftAnchor, right: view.rightAnchor , paddingLeft: 8 , height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetLabel,likeLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left:  view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor , paddingLeft: 8 , height: 1.0)
        
        return view
    }()
    
    private lazy var commentBtn: UIButton = {
        let btn = createBtn(ImageName: "comment")
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    
    private lazy var retweetBtn: UIButton = {
        let btn = createBtn(ImageName: "retweet")
        btn.addTarget(self, action: #selector(handleRetweet), for: .touchUpInside)
        return btn
    }()
    
    private lazy var likeBtn: UIButton = {
        let btn = createBtn(ImageName: "like")
        btn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shareBtn: UIButton = {
        let btn = createBtn(ImageName: "share")
        btn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return btn
    }()
    
    private let replyLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.text = "Compartilha do @andre"
        return lbl
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackLabel = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
        stackLabel.axis = .vertical
        stackLabel.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, stackLabel])
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 16)
        
        addSubview(optionBtn)
        optionBtn.centerY(inView: stack)
        optionBtn.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor,left:  leftAnchor, right: rightAnchor, paddingTop: 20, height: 40)
        
        let actionBtn = UIStackView(arrangedSubviews: [commentBtn,retweetBtn,likeBtn,shareBtn])
        actionBtn.spacing = 72
        
        addSubview(actionBtn)
        actionBtn.centerX(inView: self)
        actionBtn.anchor(top: statsView.bottomAnchor , paddingTop: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleProfileTapped() {
        
    }
    
    @objc func handleActionSheet() {
        delegate?.showActionSheet()
    }
    
    @objc func handleComment() {
        
    }
    
    @objc func handleRetweet() {
        
    }
    
    @objc func handleLike() {
        
    }
    
    @objc func handleShare() {
        
    }
    
    //MARK: - Helpers
    
    func createBtn(ImageName: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: ImageName), for: .normal)
        btn.tintColor = .darkGray
        btn.setDimensions(width: 20, height: 20)
        return btn
    }
    
    func config() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetLabel.attributedText = viewModel.retweetAtribbutedText
        likeLabel.attributedText = viewModel.likesAtribbutedText
        likeBtn.setImage(viewModel.likeBtnImage, for: .normal)
        likeBtn.tintColor = viewModel.likeBtnTint
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
}
