//
//  ShareLogoutUserView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 27/08/24.
//

import UIKit

class ShareLogoutUserView: UIView {
    private lazy var shareImage: UIImageView = {
        let image: UIImageView = UIImageView(frame: .zero)
        image.image = UIImage(systemName: "heart")
        image.widthAnchor.constraint(equalToConstant: 29).isActive = true
        image.heightAnchor.constraint(equalToConstant: 29).isActive = true
        image.layer.cornerRadius = 10
        image.backgroundColor = .systemPink
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var shareLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "Tell a Friend"
        label.font = UIFont(name: "Mulish", size: 16)
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
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ShareLogoutUserView {
    func setupView() {
        backgroundColor = .white
        
        addSubview(shareImage)
        addSubview(shareLabel)
        addSubview(chevronRightImageView)
        
        NSLayoutConstraint.activate([
            shareImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            shareImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            shareLabel.centerYAnchor.constraint(equalTo: shareImage.centerYAnchor),
            shareLabel.leadingAnchor.constraint(equalTo: shareImage.trailingAnchor, constant: 15),
            
            chevronRightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronRightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            
            heightAnchor.constraint(equalToConstant: 65),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}
