//
//  EditProfileCell.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 07/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

protocol EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    //MARK: - Propeties
    weak var delegate: EditProfileCellDelegate?
    
    var viewModel: EditProfileViewModel? {
        didSet{config()}
    }
    
    let titleLabel: UILabel = {
         let lbl = UILabel()
         lbl.font = UIFont.systemFont(ofSize: 14)
         lbl.text = "gui"
         return lbl
     }()
    
    lazy var infoTextField: UITextField = {
        let txt = UITextField()
        txt.borderStyle = .none
        txt.font = UIFont.systemFont(ofSize: 14)
        txt.textAlignment = .left
        txt.textColor = .black
        txt.addTarget(self, action: #selector(handleText), for: .editingDidEnd)
        return txt
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleText() {
        delegate?.updateUserInfo(self)
    }
    
    //MARK: - Helpers
    
    func config() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.titleText
        infoTextField.text = viewModel.optionValue
    }
}
