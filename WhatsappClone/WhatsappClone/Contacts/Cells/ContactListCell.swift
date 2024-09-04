//
//  ContactListCell.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 03/09/24.
//

import UIKit

class ContactListCell: UICollectionViewCell {
    private lazy var profileImageView: UIImageView = {
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
    
    private lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    static func getHeight() -> CGFloat {
        return 74
    }
    
    func setupData(_ user: ContactListCellModel) {
        self.usernameLabel.text = user.username
        self.statusLabel.text = user.status
    }
}

private extension ContactListCell {
    func setupView() {
        let separator: UIView = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .gray
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(chevronRightImageView)
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            
            statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 11),
            statusLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            
            chevronRightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronRightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            contentView.heightAnchor.constraint(equalToConstant: 74)
        ])
    }
}
