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
    func configBackgroundChatView()
    func configMessageCollectionView()
    func configMessageInputBar()
    func configureCustomCell()
    func configureHeaderView()
    func reloadMessages(animated: Bool)
    func navigateToProfile(user: UserModel)
    func setHeaderStatusIsTyping(isTyping: Bool)
}

protocol ChatsViewModelProtocol: AnyObject {
    var delegate: ChatsViewModelDelegate? {get set}
    func onViewDidLoad()
    func getCurrentUser() -> MKSender
    func getMKMessage() -> [MKMessage]
    func onAttachButtonDidTapped(_ text: String?)
    func getReceiveUser() -> MessageModel
    func onHeaderViewDidTapped()
    func createOldMessages()
    func userOnTyping(isTyping: Bool)
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
    private var maxChatDisplay: Int = 0
    private var minChatDisplay: Int = 0
    private var isUserTyping: Bool = false
    
    init(messageModel: MessageModel) {
        self.messageModel = messageModel
    }
    
    func onViewDidLoad() {
        listenForNewChat()
        listenForTypingStatus()
        delegate?.configBackgroundChatView()
        delegate?.configMessageCollectionView()
        delegate?.configMessageInputBar()
        delegate?.configureCustomCell()
        delegate?.configureHeaderView()
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
        
        // load chat from firebase
        if allLocalMessage == nil || allLocalMessage.isEmpty {
            FirebaseMessageListener.shared.fetchOldChat(chatId: messageModel.chatId, receiverId: messageModel.recipientId)
        }
        
        allLocalMessage = DBManager.shared.realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: keyDate, ascending: true)
        
        realmToken = allLocalMessage?.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                print("chat initialize")
                self.createMessages()
                self.delegate?.reloadMessages(animated: false)
            case .update(_ , deletions: _, insertions: let insertion, modifications: _):
                print("chat inserted")
                self.updateInputedMessages(insertion: insertion)
            case .error(let err):
                print("error: \(err.localizedDescription)")
            }
        })
    }
    
    func getReceiveUser() -> MessageModel {
        return messageModel
    }
    
    func onHeaderViewDidTapped() {
        FirebaseUserListener.shared.getUserFromFirestorById(messageModel.recipientId) { user in
            self.delegate?.navigateToProfile(user: user)
        }
    }
    
    func createOldMessages() {
        maxChatDisplay = minChatDisplay - 1
        minChatDisplay = maxChatDisplay - keyLimitChat
        
        if minChatDisplay < 0 {
            minChatDisplay = 0
        }
        
        for idx in (minChatDisplay ... maxChatDisplay).reversed() {
            createOlderMessage(allLocalMessage[idx])
        }
    }
    
    func userOnTyping(isTyping: Bool) {
        if isTyping != self.isUserTyping {
            FirebaseTypingListener.shared.saveTypingStatus(typingStatus: isTyping, chatRoomId: messageModel.chatId)
            self.isUserTyping = isTyping
        }
    }
}

private extension ChatsViewModel {
    func createMessages() {
        maxChatDisplay = allLocalMessage.count
        minChatDisplay = maxChatDisplay - keyLimitChat
        
        if minChatDisplay < 0 {
            minChatDisplay = 0
        }
        
        for idx in minChatDisplay ..< maxChatDisplay {
            createMessage(allLocalMessage[idx])
        }
    }
    
    func createMessage(_ message: LocalMessage) {
        if let localMessage = IncomeChatHelper.createMessage(localMessage: message) {
            mkMessages.append(localMessage)
        }
    }
    
    func createOlderMessage(_ message: LocalMessage) {
        if let localMessage = IncomeChatHelper.createMessage(localMessage: message) {
            mkMessages.insert(localMessage, at: 0)
        }
    }
    
    func updateInputedMessages(insertion: [Int]) {
        for idx in insertion {
            createMessage(allLocalMessage[idx])
        }
        delegate?.reloadMessages(animated: false)
    }
    
    func listenForNewChat() {
        FirebaseMessageListener.shared.listenForNewChat(chatId: messageModel.chatId, receiveId: messageModel.recipientId, lastMessageDate: lastMessageDate())
    }
    
    func lastMessageDate() -> Date {
        let lastMessage = allLocalMessage?.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second, value: 1, to: lastMessage) ?? Date()
    }
    
    func listenForTypingStatus() {
        FirebaseTypingListener.shared.setListenerForTypingStatus(chatRoomId: messageModel.chatId) { isTyping in
            self.isUserTyping = isTyping
            self.delegate?.setHeaderStatusIsTyping(isTyping: self.isUserTyping)
        }
    }
}
