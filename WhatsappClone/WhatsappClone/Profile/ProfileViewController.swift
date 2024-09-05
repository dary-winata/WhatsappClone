
//
//  ProfileViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var profileAvatarImage: UIImageView = {
        let image: UIImageView = UIImageView(frame: .zero)
        image.layer.cornerRadius = 50
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var profileUsernameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var goToMessageView: ProfileSendMessageView = {
        let viewMessage: ProfileSendMessageView = ProfileSendMessageView(frame: .zero)
        viewMessage.translatesAutoresizingMaskIntoConstraints = false
        
        return viewMessage
    }()
    
    let viewModel: ProfileViewModelProtocol
    
    init(viewModel: ProfileViewModelProtocol) {
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

extension ProfileViewController: ProfileViewModelDelegate {
    func setupView() {
        view.backgroundColor = UIColor(redMax: 235, greenMax: 235, blueMax: 235, alphaMax: 1)
        
        view.addSubview(profileAvatarImage)
        view.addSubview(profileUsernameLabel)
        view.addSubview(statusLabel)
        view.addSubview(goToMessageView)
        
        NSLayoutConstraint.activate([
            profileAvatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29),
            profileAvatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileUsernameLabel.topAnchor.constraint(equalTo: profileAvatarImage.bottomAnchor, constant: 14),
            profileUsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileUsernameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            profileUsernameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -30),
            
            statusLabel.topAnchor.constraint(equalTo: profileUsernameLabel.bottomAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            statusLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -30),
            
            goToMessageView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 21),
            goToMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goToMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            goToMessageView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func setupProfile(_ user: UserModel) {
        profileUsernameLabel.text = user.username
        statusLabel.text = user.status
        
        if user.avatar == "" {
            profileAvatarImage.image = UIImage(systemName: "person.circle.fill")
        } else {
            FirebaseStorageHelper.downloadImage(url: user.avatar) { image in
                self.profileAvatarImage.image = image
            }
        }
    }
}
