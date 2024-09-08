//
//  ChatsViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 07/09/24.
//

import Foundation
import RealmSwift
import UIKit

protocol ChatsViewModelDelegate: AnyObject {
    func configMessageCollectionView()
    func configMessageInputBar()
}

protocol ChatsViewModelProtocol: AnyObject {
    var delegate: ChatsViewModelDelegate? {get set}
    func onViewDidLoad()
    func getCurrentUser() -> MKSender
    func getMKMessage() -> [MKMessage]
    func onAttachButtonDidTapped(_ text: String?)
}

class ChatsViewModel: ChatsViewModelProtocol {
    weak var delegate: ChatsViewModelDelegate?
    
    private var messageModel: MessageModel
    private var mkMessages: [MKMessage] = []
    private var allLocalMessage: Results<LocalMessage>?
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
        loadChats()
    }
    
    func getMKMessage() -> [MKMessage] {
        return mkMessages
    }
    
    func getCurrentUser() -> MKSender {
        return currentUser
    }
    
    // Mark: Actions
    func onAttachButtonDidTapped(_ text: String?) {
        OutgoingMessageHelper.send(chatId: messageModel.chatId, text: text, membersIds: [currentUser.senderId, messageModel.recipientId])
    }
    
    // Mark: Load Chats
    func loadChats() {
        let predicate = NSPredicate(format: "\(keyChatRoomId) = %@", messageModel.chatId)
        
        allLocalMessage = DBManager.shared.realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: keyDate, ascending: true)
        
        print("got \(allLocalMessage?.count ?? 0) messages")
    }
}
