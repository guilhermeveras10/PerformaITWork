//
//  EditProfileController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 06/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//


import UIKit

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileControllerDelegate: class {
    func controller(controller: EditProfileController, user: User)
}

class EditProfileController: UITableViewController {
    //MARK: - Propeties
    
    private var user: User
    private lazy var editProfileHeader = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    
    private var userInfoChanged = false
    weak var delegate: EditProfileControllerDelegate?
    
    private var selectImage: UIImage? {
        didSet{editProfileHeader.profileImageView.image = selectImage}
    }
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
        configurateNav()
        configurateTableView()
    }
    
    //MARK: - API
    
    func update() {
        UserService.shared.saveUserData(user: user) { (error, ref) in
            self.delegate?.controller(controller: self, user: self.user)
        }
    }
    
    //MARK: - Helpers
    
    func configurateNav() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Editar Perfil"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configurateTableView() {
        tableView.tableHeaderView = editProfileHeader
        editProfileHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        editProfileHeader.delegate = self
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        update()
    }
}

//MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func didChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        cell.delegate = self
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell}
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
}


extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectImage = image
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        guard let viewModel = cell.viewModel else { return }
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let fullname = cell.infoTextField.text else { return }
            user.username = fullname
        }
    }
}
