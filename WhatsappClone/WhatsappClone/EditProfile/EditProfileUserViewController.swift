//
//  EditProfileUserViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 29/08/24.
//

import ProgressHUD
import UIKit
import YPImagePicker

class EditProfileUserViewController: UIViewController {
    
    private lazy var editProfileAvatarUsernameView: ProfileAvatarUsernameView = {
        let view: ProfileAvatarUsernameView = ProfileAvatarUsernameView(frame: .zero)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var editStatusView: StatusView = {
        let status: StatusView = StatusView(frame: .zero)
        status.translatesAutoresizingMaskIntoConstraints = false
        
        return status
    }()
    
    private var currentLeftNavigationItem: UIBarButtonItem?

    let viewModel: EditProfileUserViewModelProtocol
    
    init(viewModel: EditProfileUserViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

private extension EditProfileUserViewController {
    @objc
    func saveEditUsernameDidTapped() {
        viewModel.onSaveUserDidTapped(username: editProfileAvatarUsernameView.returnUsernameString())
    }
    
    @objc
    func cancleEditUsernameDidTapped() {
        editProfileAvatarUsernameView.setupUsernameTextField(with: viewModel.checkLastUsername())
        clearNavigationBar()
    }
}

extension EditProfileUserViewController: EditProfileUserViewModelDelegate {
    func setupView() {
        title = "Edit Profile"
        
        self.view.backgroundColor = UIColor(redMax: 235, greenMax: 235, blueMax: 235, alphaMax: 1)
        
        view.addSubview(editProfileAvatarUsernameView)
        view.addSubview(editStatusView)
        
        NSLayoutConstraint.activate([
            editProfileAvatarUsernameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editProfileAvatarUsernameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editProfileAvatarUsernameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            editStatusView.topAnchor.constraint(equalTo: editProfileAvatarUsernameView.bottomAnchor, constant: 11),
            editStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        viewModel.getProfiledataForAvatarUsername()
    }
    
    func setupImageAvatar(with image: UIImage?) {
        editProfileAvatarUsernameView.setupImageAvatarView(with: image)
    }
    
    func setupUsername(with text: String) {
        editProfileAvatarUsernameView.setupUsernameTextField(with: text)
    }
}

extension EditProfileUserViewController: ProfileAvatarUsernameViewDelegate {
    func onUsernameTextFieldDidTapped() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveEditUsernameDidTapped))
        let cancelButton = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(cancleEditUsernameDidTapped))
        
        currentLeftNavigationItem = navigationItem.leftBarButtonItem
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func onDoneTextFieldDidTapped(username: String) -> Bool {
        viewModel.onSaveUserDidTapped(username: username)
        return true
    }
    
    func onEditUsernameTextView(text: String) {
        if text == "" {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func clearNavigationBar() {
        editProfileAvatarUsernameView.endEditing(true)
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = currentLeftNavigationItem
    }
    
    func onEditProfileButtonDidTapped(_ picker: YPImagePicker) {
        viewModel.onEditProfileImageButtonDidTapped(picker)
        present(picker, animated: true, completion: nil)
    }
    
    func showProgressStatus(with value: CGFloat) {
        ProgressHUD.dismiss()
        ProgressHUD.progress(value)
    }
}
