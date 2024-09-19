//
//  OutgoingMessageHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 08/09/24.
//

import Foundation

class OutgoingMessageHelper {
    static func send(chatId: String, text: String?, membersIds: [String]) {
        guard let currentUser = FirebaseHelper.getCurrentUser else {return}
        
        let localMessage = LocalMessage()
        localMessage.id = UUID().uuidString
        localMessage.date = Date()
        localMessage.chatRoomId = chatId
        localMessage.senderId = currentUser.id
        localMessage.senderName = currentUser.username
        localMessage.senderInitial = String(currentUser.username.first ?? "?")
        localMessage.status = ChatStatusEnum.sent.rawValue
        
        if let text {
            sendTextMessage(localMessage: localMessage, text: text, membersIds: membersIds)
            FirebaseRecentChatHelper.shared.updateRecentChat(chatRoomId: chatId, lastMessage: text)
        }
    }
    
    static func sendMessage(localMessage: LocalMessage, membersIds: [String]) {
        print(localMessage)
        // save message to realm
        DBManager.shared.saveToRealm(localMessage)
        
        // send message/save to firebase
        for id in membersIds {
            FirebaseMessageListener.shared.saveMessage(localMessage, memberId: id)
        }
    }
    
    static func sendTextMessage(localMessage: LocalMessage, text: String, membersIds: [String]) {
        localMessage.type = SendChatTypeEnum.text.rawValue
        localMessage.message = text
        sendMessage(localMessage: localMessage, membersIds: membersIds)
    }
}
