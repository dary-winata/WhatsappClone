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
    private lazy var attachFileButton: InputBarButtonItem = {
        let inputBar: InputBarButtonItem = InputBarButtonItem()
        inputBar.image = UIImage(systemName: "plus")
        let gesture = UITapGestureRecognizer(target: ChatsViewController.self, action: #selector(attachButtonDidTapped))
        inputBar.addGestureRecognizer(gesture)
        
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
}

private extension ChatsViewController {
    @objc
    private func attachButtonDidTapped() {
        print("attach tapped")
    }
}

extension ChatsViewController: ChatsViewModelDelegate {
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
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.inputTextView.layer.cornerRadius = 18
        messageInputBar.inputTextView.layer.borderWidth = 0.5
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        messageInputBar.setStackViewItems([attachFileButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 24, animated: false)
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

private extension ChatsViewController {
    @objc
    func onHeaderViewDidTapped() {
        print("testing")
        viewModel.onHeaderViewDidTapped()
    }
}
