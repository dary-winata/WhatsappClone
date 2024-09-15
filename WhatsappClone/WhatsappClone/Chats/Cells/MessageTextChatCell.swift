//
//  MessageTextChatCell.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 08/09/24.
//

import Foundation
import MessageKit

class CustomTextViewCell: MessageContentCell {
    private lazy var allView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .green
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var statusStackView: UIStackView = {
        let stack: UIStackView = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var statusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(redMax: 130, greenMax: 130, blueMax: 135, alphaMax: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(redMax: 130, greenMax: 130, blueMax: 135, alphaMax: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var separatorStatusLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "·"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(redMax: 130, greenMax: 130, blueMax: 135, alphaMax: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var isSender: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let chatViewInset = UIEdgeInsets(top: 12, left: 12, bottom: 32, right: 12)
    
    func setupView() {
        messageContainerView.addSubview(allView)
        NSLayoutConstraint.activate([
            allView.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            allView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor),
        ])
        
        allView.addSubview(textLabel)
        allView.addSubview(statusStackView)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: allView.topAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: allView.leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: allView.trailingAnchor, constant: -10),
            
            statusStackView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
            statusStackView.leadingAnchor.constraint(greaterThanOrEqualTo: allView.leadingAnchor, constant: 10),
            statusStackView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
            statusStackView.bottomAnchor.constraint(equalTo: allView.bottomAnchor, constant: -10),
        ])
        
        statusStackView.addArrangedSubview(timeLabel)
        statusStackView.addArrangedSubview(separatorStatusLabel)
        statusStackView.addArrangedSubview(statusLabel)
        
    }
    
    override func configure(with message: any MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let mkMessage = message as? MKMessage else {return}
        
        switch mkMessage.kind {
        case.text(let text):
            textLabel.text = text
            timeLabel.text = mkMessage.sentDate.timeDate()
            statusLabel.text = mkMessage.status
        default:
            break
        }
        
        if messagesCollectionView.messagesDataSource?.isFromCurrentSender(message: mkMessage) ?? true {
            NSLayoutConstraint.activate([
                allView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor),
                allView.leadingAnchor.constraint(greaterThanOrEqualTo: messageContainerView.leadingAnchor)
            ])
            allView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
            
            allView.backgroundColor = UIColor(named: "chat_output")
        } else {
            
        }
    }
    
    
}

class CustomTextCalculatorSize: TextMessageSizeCalculator {
    var uiLabelTextTesting: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    override func messageContainerSize(for message: any MessageType) -> CGSize {
        switch message.kind {
        case .text(let text):
            uiLabelTextTesting.text = text
            
            let maxWidth = floor(UIScreen.main.bounds.width * 0.75)
            return CGSize(width: maxWidth, height: calculateTextHeight(text: text, maxScreenWidth: maxWidth))
        default:
            fatalError("error")
        }
    }
    
    private func calculateTextHeight(text: String, maxScreenWidth: CGFloat) -> Double {
        let size: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        var height: Double = ceil(size.height)
        var currentLength = size.width
        while(currentLength > maxScreenWidth) {
            height += ceil(size.height)
            currentLength -= maxScreenWidth
        }
        
        return height + 12 + 20 + 8
    }
}
