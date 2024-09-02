//
//  EditProfileAvatarUsernameView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 31/08/24.
//

import UIKit
import YPImagePicker

protocol ProfileAvatarUsernameViewDelegate: AnyObject {
    func onUsernameTextFieldDidTapped()
    func onDoneTextFieldDidTapped(username: String) -> Bool
    func onEditUsernameTextView(text: String)
    func onEditProfileButtonDidTapped(_ picker: YPImagePicker)
}

class ProfileAvatarUsernameView: UIView {
    private lazy var avatarPictureImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 26
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var editProfileTitleLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "Enter your name and add an optional profile picture"
        label.numberOfLines = 2
        label.textColor = .gray
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.addTarget(self, action: #selector(editProfileButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var editUsernameTextView: UITextField = {
        let textField: UITextField = UITextField(frame: .zero)
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.heightAnchor.constraint(equalToConstant: 22).isActive = true
        textField.delegate = self
        textField.resignFirstResponder()
        textField.selectedTextRange = nil
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.addTarget(self, action: #selector(usernameTextFieldDidChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var imagePicker: YPImagePicker = {
        var config: YPImagePickerConfiguration = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.library.maxNumberOfItems = 3
        config.screens = [.library]
        
        let picker: YPImagePicker = YPImagePicker(configuration: config)
        return picker
    }()
    
    weak var delegate: ProfileAvatarUsernameViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func returnUsernameString() -> String {
        guard let text = editUsernameTextView.text else { return "" }
        
        return text
    }
    
    func setupUsernameTextField(with text: String) {
        editUsernameTextView.text = text
    }
    
    func setupImageAvatarView(with image: UIImage) {
        self.avatarPictureImageView.image = image
    }
}

private extension ProfileAvatarUsernameView {
    @objc
    func usernameTextFieldDidTapped() {
        delegate?.onUsernameTextFieldDidTapped()
    }
    
    @objc
    func usernameTextFieldDidChanged() {
        guard let text = editUsernameTextView.text else {return}
        delegate?.onEditUsernameTextView(text: text)
    }
    
    @objc
    func editProfileButtonDidTapped() {
        delegate?.onEditProfileButtonDidTapped(imagePicker)
    }
    
    func setupView() {
        backgroundColor = .white
        
        let usernameSeparator: UIView = UIView(frame: .zero)
        usernameSeparator.backgroundColor = UIColor(redMax: 235, greenMax: 235, blueMax: 235, alphaMax: 1)
        usernameSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatarPictureImageView)
        addSubview(editProfileTitleLabel)
        addSubview(editProfileButton)
        addSubview(usernameSeparator)
        addSubview(editUsernameTextView)
        
        NSLayoutConstraint.activate([
            avatarPictureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            avatarPictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            editProfileTitleLabel.topAnchor.constraint(equalTo: avatarPictureImageView.topAnchor),
            editProfileTitleLabel.leadingAnchor.constraint(equalTo: avatarPictureImageView.trailingAnchor, constant: 14),
            editProfileTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            
            editProfileButton.centerXAnchor.constraint(equalTo: avatarPictureImageView.centerXAnchor),
            editProfileButton.topAnchor.constraint(equalTo: avatarPictureImageView.bottomAnchor),
            
            usernameSeparator.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 10),
            usernameSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            usernameSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            usernameSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            editUsernameTextView.topAnchor.constraint(equalTo: usernameSeparator.bottomAnchor, constant: 12),
            editUsernameTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            editUsernameTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            
            heightAnchor.constraint(equalToConstant: 140)
        ])
        
        guard let user = FirebaseHelper.getCurrentUser else {return}
        setupProfile(user: user)
    }
    
    func setupProfile(user: UserModel) {
        if user.avatar.isEmpty {
            avatarPictureImageView.image = UIImage(systemName: "person.fill")
        } else {
            
        }
        editUsernameTextView.text = user.username
        editUsernameTextView.placeholder = user.username
    }
}

extension ProfileAvatarUsernameView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.onUsernameTextFieldDidTapped()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editUsernameTextView {
            guard let text = textField.text else {return false}
            return delegate?.onDoneTextFieldDidTapped(username: text) ?? false
        }
        
        return false
    }
    
}
