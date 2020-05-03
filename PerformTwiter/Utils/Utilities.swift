//
//  Utilities.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 26/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

class Utilities {
    
    func inputViewContainer(image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .black
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 0.75)
        
        return view
    }
    
    func configureTextfield(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return tf
    }
    
    func btnInitial(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.rgb(red: 177/255, green: 176/255, blue: 176/255)
        btn.setTitleColor(.white, for: .normal)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.setTitle(title, for: .normal)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return btn
    }
    
    func dontHaveAccountBtn(firstText: String, secondText: String) -> UIButton {
        let btn = UIButton(type: .system)
        
        let attributText = NSMutableAttributedString(string: firstText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        
        attributText.append(NSAttributedString(string: secondText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        
        btn.setAttributedTitle(attributText, for: .normal)
        
        return btn
    }
    
    func TweetsCellBtn(image: String) -> UIButton {
        
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: image), for: .normal)
        btn.tintColor = .darkGray
        btn.setDimensions(width: 20, height: 20)
        return btn 
    }
}
