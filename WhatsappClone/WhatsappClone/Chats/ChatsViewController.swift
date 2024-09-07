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
        self.view.backgroundColor = .yellow
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
        
        
    }
    
    
}

