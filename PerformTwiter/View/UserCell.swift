//
//  UserCell.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 29/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    //MARK: - Propeties
    
    var user: User? {
        didSet{config()}
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .black
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.systemFont(ofSize: 14)
         lbl.text = "gui"
         return lbl
     }()
    
    private let usernameLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.boldSystemFont(ofSize: 14)
         lbl.text = "gui"
         return lbl
     }()
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func config() {
        profileImageView.sd_setImage(with: user?.profileImageUrl)
        fullnameLabel.text = user?.fullname
        usernameLabel.text = user?.username
    }
}
