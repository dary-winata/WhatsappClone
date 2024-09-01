//
//  EditProfileAvatarUsernameView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 31/08/24.
//

import UIKit

protocol ProfileAvatarUsernameViewDelegate: AnyObject {
    func onUsernameTextFieldDidTapped()
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    weak var delegate: ProfileAvatarUsernameViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileAvatarUsernameView {
    @objc
    func usernameTextFieldDidTapped() {
        delegate?.onUsernameTextFieldDidTapped()
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
    }
}

extension ProfileAvatarUsernameView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.onUsernameTextFieldDidTapped()
    }
}
