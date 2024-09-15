//
//  ChatHeaderView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 15/09/24.
//

import UIKit

class ChatHeaderView: UIView {
    private lazy var avatarImage: UIImageView = {
        let image: UIImageView = UIImageView(frame: .zero)
        image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        image.widthAnchor.constraint(equalToConstant: 36).isActive = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 18
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(redMax: 130, greenMax: 130, blueMax: 135, alphaMax: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChatHeaderView {
    func setupView() {
        addSubview(avatarImage)
        addSubview(usernameLabel)
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),
            
            statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor)
        ])
    }
}
