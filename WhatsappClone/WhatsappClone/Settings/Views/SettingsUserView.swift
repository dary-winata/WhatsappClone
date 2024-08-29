//
//  SettingsUserView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 25/08/24.
//

import UIKit

class SettingsUserView: UIView {
    private lazy var avatarImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 26
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        label.text = "Budi"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var userStatusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
//        label.text = "Chat Only"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var chevronRightImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupModel(username: String, status: String) {
        usernameLabel.text = username
        userStatusLabel.text = status
    }
}

private extension SettingsUserView {
    func setupView() {
        backgroundColor = .white
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(userStatusLabel)
        addSubview(chevronRightImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            
            userStatusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            userStatusLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            
            chevronRightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronRightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            
            heightAnchor.constraint(equalToConstant: 74),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}
