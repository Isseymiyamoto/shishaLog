//
//  EditProfileController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/06/24.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}

class EditProfileController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let footerView = EditProfileFooter()
    private let imagePicker = UIImagePickerController()
    weak var delegate: EditProfileControllerDelegate?
    
    private var userInfoChanged = false
    
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    private var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage }
    }

    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationBar()
        configureImagePicker()
       
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadProfileInfo(){
        view.endEditing(true)
        guard imageChanged || userInfoChanged else { return }
        updateUserInfo()
    }
    
    // MARK: - API
    
    func updateUserInfo(){
        
        if imageChanged && userInfoChanged{
            UserService.shared.saveUserData(user: user) { (err, ref) in
                self.updateProfileImage()
            }
        }
        
        if imageChanged && !userInfoChanged{
            updateProfileImage()
        }
        
        if !imageChanged && userInfoChanged{
            UserService.shared.saveUserData(user: user) { (err, ref) in
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
    }
    
    func updateProfileImage(){
        guard let image = selectedImage else { return }
        UserService.shared.updateProfileImage(image: image) { (url) in
            self.user.profileImageUrl = url
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    // MARK: - Helpers
    
    func configureTableView(){
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        footerView.delegate = self
    }
    
    func configureNavigationBar(){
        
        navigationItem.title = "プロフィールを編集"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(handleUploadProfileInfo))
    }
    
    func configureImagePicker(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

}

// MARK: - UITableViewDataSource / Delegate

extension EditProfileController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 40
    }
}

// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate{
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate{
    func updateUserInfo(_ cell: EditProfileCell) {
        
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - EditProfileFooterDelegate

extension EditProfileController: EditProfileFooterDelegate{
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "本当にログアウトしても良いですか？", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "ログアウト", style: .destructive, handler: { (_) in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

