//
//  ChatsViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 24/08/24.
//

import InputBarAccessoryView
import MessageKit
import UIKit

class ChatsViewController: MessagesViewController {
    private lazy var backgroundChat: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "chat_bg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var attachFileButton: InputBarButtonItem = {
        let inputBar: InputBarButtonItem = InputBarButtonItem()
        inputBar.image = UIImage(systemName: "plus")
        inputBar.setSize(CGSize(width: 18.6, height: 18.6), animated: false)
        inputBar.onTouchUpInside { _ in
            self.attachButtonDidTapped()
        }
        
        return inputBar
    }()
    
    private lazy var cameraButton: InputBarButtonItem = {
        let inputBar: InputBarButtonItem = InputBarButtonItem()
        inputBar.image = UIImage(systemName: "camera")
        inputBar.setSize(CGSize(width: 22, height: 19), animated: false)
        inputBar.onTouchUpInside { _ in
            self.cameraButtonDidTapped()
        }
        
        return inputBar
    }()
    
    private lazy var microphoneButton: InputBarButtonItem = {
        let inputBar: InputBarButtonItem = InputBarButtonItem()
        inputBar.image = UIImage(systemName: "mic")
        inputBar.setSize(CGSize(width: 15.7, height: 23.1), animated: false)
        inputBar.onTouchUpInside { _ in
            self.microphoneButtonDidTapped()
        }
        
        return inputBar
    }()
    
    private lazy var headerChatView: ChatHeaderView = {
        let headerView: ChatHeaderView = ChatHeaderView(frame: .zero)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHeaderViewDidTapped))
        headerView.addGestureRecognizer(tapGesture)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        return headerView
    }()
    
    let viewModel: ChatsViewModelProtocol
    
    init(viewModel: ChatsViewModelProtocol) {
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
    
    func onChatMessageIsEdited(isEdited: Bool) {
        if isEdited {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
        } else {
            messageInputBar.setStackViewItems([cameraButton, microphoneButton], forStack: .right, animated: false)
        }
    }
}

private extension ChatsViewController {
    func attachButtonDidTapped() {
        print("attach tapped")
    }
    
    func cameraButtonDidTapped() {
        print("camera did tapped")
    }
    
    func microphoneButtonDidTapped() {
        print("microphone did tapped")
    }
    
    @objc
    func onHeaderViewDidTapped() {
        print("testing")
        viewModel.onHeaderViewDidTapped()
    }
}

extension ChatsViewController: ChatsViewModelDelegate {
    func configBackgroundChatView() {
        messagesCollectionView.backgroundView = backgroundChat
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.rightStackView.alignment = .center
        
        NSLayoutConstraint.activate([
            backgroundChat.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundChat.leadingAnchor.constraint(equalTo: messagesCollectionView.leadingAnchor),
            backgroundChat.trailingAnchor.constraint(equalTo: messagesCollectionView.trailingAnchor),
            backgroundChat.bottomAnchor.constraint(equalTo: messagesCollectionView.bottomAnchor)
        ])
    }
    
    func configMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    
    func configMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.sendButton.title = ""
        let image: UIImage? = UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        messageInputBar.sendButton.image = image
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.inputTextView.layer.cornerRadius = 18
        messageInputBar.inputTextView.layer.borderWidth = 0.5
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        messageInputBar.setStackViewItems([attachFileButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 24, animated: false)
        messageInputBar.rightStackView.spacing = 1
        onChatMessageIsEdited(isEdited: false)
    }
    
    func configureCustomCell() {
        messagesCollectionView.register(CustomTextViewCell.self)
        
        // custom chat calc
        let textCal = CustomTextCalculatorSize(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
        messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator = textCal
        
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
    }
    
    func configureHeaderView() {
        self.navigationItem.titleView = headerChatView
        
        if let navbar = navigationController?.navigationBar {
            headerChatView.widthAnchor.constraint(equalToConstant: navbar.frame.width).isActive = true
            headerChatView.heightAnchor.constraint(equalToConstant: navbar.frame.height).isActive = true
        }
        
        let messageModel = viewModel.getReceiveUser()
        headerChatView.setupData(avatarImage: messageModel.recipientAvatar, username: messageModel.recipientName, status: "Tap here for contact info")
    }
    
    func reloadMessages(animated: Bool) {
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: animated)
    }
    
    func navigateToProfile(user: UserModel) {
        let profileVM = ProfileViewModel(user: user)
        let profileVC = ProfileViewController(viewModel: profileVM)
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
