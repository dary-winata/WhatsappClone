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
    private var attachFileButton: InputBarButtonItem = {
        let inputBar: InputBarButtonItem = InputBarButtonItem()
        inputBar.image = UIImage(systemName: "plus")
        let gesture = UITapGestureRecognizer(target: ChatsViewController.self, action: #selector(attachButtonDidTapped))
        inputBar.addGestureRecognizer(gesture)
        
        return inputBar
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
}

