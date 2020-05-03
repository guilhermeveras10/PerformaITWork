//
//  ProfileHeader.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 28/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func handleDismiss()
    func handlProfile(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Propeties
    
    var user: User? {
        didSet { config() }
    }
    
    private let filterBar = ProfileFilterView()
    
    weak var delegate: ProfileHeaderDelegate?
    
    private lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        
        view.addSubview(backBtn)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 12)
        backBtn.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        
        return iv
    }()
    
    lazy var editProfileFollowBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Carregando", for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.25
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return btn
    }()
    
    private let fullnameLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.boldSystemFont(ofSize: 20)
         lbl.text = "gui"
         return lbl
     }()
    
    private let usernameLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = .lightGray
         lbl.text = "gui"
         return lbl
     }()
    
    private let bioLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.systemFont(ofSize: 16)
         lbl.numberOfLines = 3
         lbl.text = "algum text algum textalgum textalgum textalgum textalgum textalgum text"
         return lbl
     }()
    
    private let underlineView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let followersLabel: UILabel = {
        let lbl = UILabel()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        lbl.addGestureRecognizer(tap)
        lbl.isUserInteractionEnabled = true
        
        return lbl
    }()
    
    private let followingLabel: UILabel = {
        let lbl = UILabel()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        lbl.addGestureRecognizer(tap)
        lbl.isUserInteractionEnabled = true
        
        return lbl
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowBtn)
        editProfileFollowBtn.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        editProfileFollowBtn.setDimensions(width: 100, height: 36)
        editProfileFollowBtn.layer.cornerRadius = 36 / 2
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel,bioLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let stackF = UIStackView(arrangedSubviews: [followingLabel,followersLabel])
        stackF.axis = .horizontal
        stackF.spacing = 8
        stackF.distribution = .fillEqually
        
        addSubview(stackF)
        stackF.anchor(top: stack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    @objc func handleEditProfileFollow() {
        delegate?.handlProfile(self)
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    //MARK: - Helpers
    
    func config() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        editProfileFollowBtn.setTitle(viewModel.actionBtnTitle, for: .normal)
        fullnameLabel.text = viewModel.fullname
        usernameLabel.text = viewModel.username
        profileImageView.sd_setImage(with: user.profileImageUrl)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
    }
}

//MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFielterCell else { return }
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
