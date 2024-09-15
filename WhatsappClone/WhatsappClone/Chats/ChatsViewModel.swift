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
    func configureCustomCell()
    func reloadMessages(animated: Bool)
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
    private var allLocalMessage: Results<LocalMessage>!
    private var currentUser: MKSender = {
        guard let currentUser = FirebaseHelper.getCurrentUser else {return MKSender(senderId: "", displayName: "")}
        let sender: MKSender = MKSender(senderId: currentUser.id, displayName: currentUser.username)
        return sender
    }()
    private var realmToken: NotificationToken?
    
    init(messageModel: MessageModel) {
        self.messageModel = messageModel
    }
    
    func onViewDidLoad() {
        delegate?.configMessageCollectionView()
        delegate?.configMessageInputBar()
        delegate?.configureCustomCell()
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
        
        realmToken = allLocalMessage?.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                print("chat initialize")
                self.createMessages()
                self.delegate?.reloadMessages(animated: false)
            case .update(_ , deletions: _, insertions: let insertion, modifications: _):
                print("data: \(insertion.first!)")
                self.updateInputedMessages(insertion: insertion)
            case .error(let err):
                print("error: \(err.localizedDescription)")
            }
        })
    }
}

private extension ChatsViewModel {
    func createMessages() {
        for message in allLocalMessage {
            createMessage(message)
        }
    }
    
    func createMessage(_ message: LocalMessage) {
        if let localMessage = IncomeChatHelper.createMessage(localMessage: message) {
            mkMessages.append(localMessage)
            print("create message \(message.message)")
        }
    }
    
    func updateInputedMessages(insertion: [Int]) {
        for idx in insertion {
            createMessage(allLocalMessage[idx])
        }
        delegate?.reloadMessages(animated: false)
    }
}
