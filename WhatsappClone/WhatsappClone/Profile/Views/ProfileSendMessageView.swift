//
//  ProfileSendMessageView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import UIKit

class ProfileSendMessageView: UIView {
//    private lazy var iconChatImage: UIImageView = {
//        let imageView: UIImageView = UIImageView(frame: .zero)
//        imageView.image = UIImage(systemName: "message.fill")
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = UIColor(redMax: 237, greenMax: 237, blueMax: 255, alphaMax: 1)
//        imageView.layer.cornerRadius = 18
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 7
//        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return imageView
//    }()
    
    private lazy var iconChatImage: BubbleCircleView = {
        let imageView: BubbleCircleView = BubbleCircleView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var sendMessageLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "Send a message"
        label.font = UIFont.systemFont(ofSize: 16)
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
}

private extension ProfileSendMessageView {
    private func setupView() {
        backgroundColor = .white
        
        addSubview(iconChatImage)
        addSubview(sendMessageLabel)
        addSubview(chevronRightImageView)
        
        NSLayoutConstraint.activate([
            iconChatImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconChatImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            sendMessageLabel.leadingAnchor.constraint(equalTo: iconChatImage.trailingAnchor, constant: 11),
            sendMessageLabel.trailingAnchor.constraint(greaterThanOrEqualTo: chevronRightImageView.leadingAnchor, constant: -16),
            sendMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevronRightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronRightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            
            heightAnchor.constraint(equalToConstant: 47)
        ])
    }
}

class BubbleCircleView: UIView {
    private var bubbleImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "message.fill")
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(redMax: 237, greenMax: 237, blueMax: 255, alphaMax: 1)
        
        addSubview(bubbleImageView)
        
        NSLayoutConstraint.activate([
            bubbleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            bubbleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            bubbleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bubbleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            bubbleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bubbleImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
