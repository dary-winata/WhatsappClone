//
//  RecentChatCell.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import UIKit

class RecentChatCell: UITableViewCell {
    private lazy var avatarImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 26
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var lastMessageLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
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
    
    private lazy var counterView: UnreadCounterView = {
        let counterView: UnreadCounterView = UnreadCounterView(frame: .zero)
        counterView.layer.cornerRadius = 15
        counterView.layer.masksToBounds = true
        counterView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        counterView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        counterView.translatesAutoresizingMaskIntoConstraints = false
        
        return counterView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupModel(_ recentChat: RecentMessageModel) {
        if recentChat.avatar == "" {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
        } else {
            FirebaseStorageHelper.downloadImage(url: recentChat.avatar) { image in
                self.avatarImageView.image = image
            }
        }
        lastMessageLabel.text = recentChat.lastMessage
        usernameLabel.text = recentChat.recieverId == FirebaseHelper.getCurrentId ? recentChat.senderName : recentChat.recieverName
        
        if recentChat.unreadCounter == 0 {
            counterView.isHidden = true
        } else {
            counterView.isHidden = false
            counterView.setupUnreadCounter(recentChat.unreadCounter)
        }
        dateLabel.text = timeElapsed(recentChat.date ?? Date())
    }
}

private extension RecentChatCell {
    func setupView() {
        let separator: UIView = UIView(frame: .zero)
        separator.backgroundColor = .gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(lastMessageLabel)
        addSubview(dateLabel)
        addSubview(chevronRightImageView)
        addSubview(counterView)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -16),
//            usernameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: chevronRightImageView.leadingAnchor, constant: -16),
            
            lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 11),
            lastMessageLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            lastMessageLabel.trailingAnchor.constraint(lessThanOrEqualTo: counterView.leadingAnchor, constant: -16),
//            lastMessageLabel.trailingAnchor.constraint(greaterThanOrEqualTo: chevronRightImageView.leadingAnchor, constant: -16),
            lastMessageLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: chevronRightImageView.leadingAnchor, constant: -10),
            
            counterView.bottomAnchor.constraint(equalTo: lastMessageLabel.bottomAnchor),
            counterView.trailingAnchor.constraint(equalTo: chevronRightImageView.leadingAnchor, constant: -8),
            
            chevronRightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronRightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            heightAnchor.constraint(equalToConstant: 74)
        ])
    }
}


class UnreadCounterView: UIView {
    private lazy var counterLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
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
    
    func setupUnreadCounter(_ count: Int) {
        if count < 100 {
            counterLabel.text = "\(count)"
        } else {
            counterLabel.text = "99+"
        }
    }
    
    func setupView() {
        backgroundColor = UIColor(redMax: 5, greenMax: 97, blueMax: 98, alphaMax: 1)
        addSubview(counterLabel)
        
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            counterLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}
