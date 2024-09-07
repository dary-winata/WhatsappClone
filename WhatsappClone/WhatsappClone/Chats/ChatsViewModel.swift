//
//  ChatsViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 07/09/24.
//

import Foundation

protocol ChatsViewModelDelegate: AnyObject {
    func configMessageCollectionView()
    func configMessageInputBar()
}

protocol ChatsViewModelProtocol: AnyObject {
    var delegate: ChatsViewModelDelegate? {get set}
    func onViewDidLoad()
    func getCurrentUser() -> MKSender
    func getMKMessage() -> [MKMessage]
}

class ChatsViewModel: ChatsViewModelProtocol {
    weak var delegate: ChatsViewModelDelegate?
    
    private var messageModel: MessageModel
    private var mkMessages: [MKMessage] = []
    private var currentUser: MKSender = {
        guard let currentUser = FirebaseHelper.getCurrentUser else {return MKSender(senderId: "", displayName: "")}
        let sender: MKSender = MKSender(senderId: currentUser.id, displayName: currentUser.username)
        return sender
    }()
    
    init(messageModel: MessageModel) {
        self.messageModel = messageModel
    }
    
    func onViewDidLoad() {
        delegate?.configMessageCollectionView()
        delegate?.configMessageInputBar()
    }
    
    func getMKMessage() -> [MKMessage] {
        return getMKMessage()
    }
    
    func getCurrentUser() -> MKSender {
        return currentUser
    }
}
