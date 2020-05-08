//
//  UploadTwiiterController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 27/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import ActiveLabel

class UploadTwiiterController: UIViewController {
    
    //MARK: - Propeties
    
    private let user: User
    
    private let config: UploadConfiguration
    
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var replyLabel: ActiveLabel = {
        let lbl = ActiveLabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .lightGray
        lbl.mentionColor = .blue
        lbl.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return lbl
    }()
    
    private let captionTextView = CaptionTextView()
    
    private let actionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .black
        btn.setTitle("Rasga", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        btn.layer.cornerRadius = 32/2
        btn.addTarget(self, action: #selector(tweet), for: .touchUpInside)
        return btn
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 48 / 2
        return iv
    }()
    
    //MARK: - Lifecycle
    
    init(user: User, config: UploadConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        handleMentionTap()
        
        switch config {
        case .tweet: print("edgf")
        case .reply(let tweet): print(tweet.caption)
        }
    }
    
    //MARK: - Helpers
    
    func handleMentionTap() {
        replyLabel.handleMentionTap { mention in
            
        }
    }
    
    func configureInterface() {
        view.backgroundColor = .white
        configureNavigationBar()
        let imageCaptiom = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        imageCaptiom.axis = .horizontal
        imageCaptiom.spacing = 12
        imageCaptiom.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptiom])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        actionBtn.setTitle(viewModel.actionBtnTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        replyLabel.isHidden = !viewModel.shouldShowReplyText
        guard let replyText = viewModel.replyText else {return}
        replyLabel.text = replyText
    }
    
    func configureInterfaceComponents() {
        
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionBtn)
    }
    
    //MARK: - Selectors
    
    @objc func tweet() {
        guard let caption = captionTextView.text else { return }
        TweetsSeervice.shared.sendTweets(caption: caption, type: config) { (error, ref) in
            if let error = error {
                self.showError(error.localizedDescription)
                return
            }
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
