//
//  ChatHeaderView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 15/09/24.
//

import UIKit

class ChatHeaderView: UIView {
    private lazy var avatarImageView: UIImageView = {
        let image: UIImageView = UIImageView(frame: .zero)
        image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        image.widthAnchor.constraint(equalToConstant: 36).isActive = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 18
        image.layer.masksToBounds = true
        image.image = UIImage(systemName: "person.circle.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Username"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(redMax: 130, greenMax: 130, blueMax: 135, alphaMax: 1)
        label.text = "Status"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(avatarImage: String, username: String, status: String) {
        usernameLabel.text = username
        statusLabel.text = status
        if avatarImage == "" {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
        } else {
            FirebaseStorageHelper.downloadImage(url: avatarImage) { image in
                self.avatarImageView.image = image
            }
        }
    }
    
    func setupStatusTyping(isTyping: Bool) {
        statusLabel.text = isTyping ? "Typing..." : "Tap This For Viewing Profile"
    }
}

private extension ChatHeaderView {
    func setupView() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor)
        ])
    }
}
