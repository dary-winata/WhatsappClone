//
//  EditStatusView.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 31/08/24.
//

import UIKit

class StatusView: UIView {
    private lazy var statusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var chevronRightImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
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

private extension StatusView {
    func setupView() {
        backgroundColor = .white
        
        addSubview(statusLabel)
        addSubview(chevronRightImageView)
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevronRightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronRightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            
            heightAnchor.constraint(equalToConstant: 47)
        ])
        
        guard let status = FirebaseHelper.getCurrentUser?.status else {return}
        setupStatus(status: status)
    }
    
    func setupStatus(status: String) {
        statusLabel.text = status
    }
}
