//
//  EditProfileHeader.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 07/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    //MARK: - Propeties
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        
        return iv
    }()
    
    private let changePhoto: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Escolher nova foto", for: .normal)
        btn.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .black
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(changePhoto)
        changePhoto.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    
    //MARK: - Selectors
    
    @objc func handleChangePhoto() {
        delegate?.didChangeProfilePhoto()
    }
}
