//
//  NotificationCell.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 04/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate: class {
    func selectProfileImage(_ cell: NotificationCell)
    func didFollowTap(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    //MARK: - Propeties
    
    var notification: Notificacion? {
        didSet{config()}
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    let notificationLabel: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.text = "algum texto"
        return lbl
    }()
    
    private lazy var followBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Carregando", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
        btn.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [profileImageView,notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
        
        addSubview(followBtn)
        followBtn.centerY(inView: self)
        followBtn.setDimensions(width: 92, height: 32)
        followBtn.layer.cornerRadius = 32 / 2
        followBtn.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleProfileTapped() {
        delegate?.selectProfileImage(self)
    }
    
    @objc func handleFollow() {
        delegate?.didFollowTap(self)
    }
    
    //MARK: - Helpers
    
    func config() {
        guard let notification = notification else { return }
        let viewModel = NotificacionViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        followBtn.isHidden = viewModel.shouldHideFollowBtn
        followBtn.setTitle(viewModel.followBtnText, for: .normal)
    }
}
