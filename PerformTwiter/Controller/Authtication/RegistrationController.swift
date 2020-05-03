//
//  RegistrationController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 24/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Propeties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let btnChangePhoto: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return btn
    }()
    
    private lazy var emailContainer: UIView = {
        let image = #imageLiteral(resourceName: "mail")
        let view = Utilities().inputViewContainer(image: image, textField: emailTextField)
        return view
    }()
    
    private lazy var pwdContainer: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputViewContainer(image: image!, textField: pwdTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().configureTextfield(placeholder: "E-mail")
        return tf
    }()
    
    private let pwdTextField: UITextField = {
        let tf = Utilities().configureTextfield(placeholder: "Senha")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var fullnameContainer: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputViewContainer(image: image!, textField: fullnameTextField)
        return view
    }()
    
    private lazy var usernameContainer: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputViewContainer(image: image!, textField: usernameTextField)
        return view
    }()
    
    private let fullnameTextField: UITextField = {
        let tf = Utilities().configureTextfield(placeholder: "Nome completo")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().configureTextfield(placeholder: "Apelido")
        return tf
    }()
    
    private let btnSignUp: UIButton = {
        let btn = Utilities().btnInitial(title: "Cadastrar")
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    private let btnHaveAccount: UIButton = {
        let btn = Utilities().dontHaveAccountBtn(firstText: "Já possui conta ?", secondText: " Entre")
        btn.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        view.backgroundColor = .white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(btnChangePhoto)
        btnChangePhoto.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        btnChangePhoto.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer,pwdContainer,fullnameContainer,usernameContainer,btnSignUp])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: btnChangePhoto.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(btnHaveAccount)
        btnHaveAccount.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
    }
    
    //MARK: - Selectors
    
    @objc func handlePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let profileImage = profileImage else {
            return
        }
        guard let email = emailTextField.text else { return }
        guard let pwd = pwdTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        
        let credentials = AuthCredentials(email: email, pwd: pwd, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registredUser(credentials: credentials) { (error, ref) in
            if let error = error {
                self.showError(error.localizedDescription)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImega = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImega
        self.btnChangePhoto.setImage(profileImega.withRenderingMode(.alwaysOriginal), for: .normal)
        self.btnChangePhoto.layer.cornerRadius = 128 / 2
        self.btnChangePhoto.layer.masksToBounds = true
        self.btnChangePhoto.imageView?.contentMode = .scaleAspectFill
        self.btnChangePhoto.imageView?.clipsToBounds = true
        self.btnChangePhoto.layer.borderColor = UIColor.white.cgColor
        self.btnChangePhoto.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
}
