//
//  LoginController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 23/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Propeties
    
    private let imageLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "PerformaIT_LOGO")
        return iv
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
    
    private let btnLogin: UIButton = {
        let btn = Utilities().btnInitial(title: "Entrar")
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    private let btnDontHaveAccount: UIButton = {
        let btn = Utilities().dontHaveAccountBtn(firstText: "É funcionário ?", secondText: " Cadastre-se")
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
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
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
        
        view.addSubview(imageLogo)
        imageLogo.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        imageLogo.setDimensions(width: 270, height: 270)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer,pwdContainer,btnLogin])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: imageLogo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(btnDontHaveAccount)
        btnDontHaveAccount.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
    }
    
    //MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let pwd = pwdTextField.text else { return }
        
        AuthService.shared.logIn(email: email, pwd: pwd) { (result, error) in
            if let error = error {
                self.showError(error.localizedDescription)
                return
            }
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {
                return
            }
            guard let tab = window.rootViewController as? MainTabBarController else { return }
            tab.authenticadUser()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
