//
//  OutgoingMessageHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 08/09/24.
//

import Foundation

class OutgoingMessageHelper {
    static func send(chatId: String, text: String?) {
        guard let currentUser = FirebaseHelper.getCurrentUser else {return}
        
        var localMessage = LocalMessage()
        localMessage.id = UUID().uuidString
        localMessage.date = Date()
        localMessage.chatRoomID = chatId
        localMessage.senderId = currentUser.id
        localMessage.senderName = currentUser.username
        localMessage.senderInitial = String(currentUser.username.first ?? "?")
        localMessage.status = ChatStatusEnum.sent.rawValue
        
        if let text {
            sendTextMessage(localMessage: localMessage, text: text)
        }
    }
    
    static func sendMessage(localMessage: LocalMessage) {
        print(localMessage)
    }
    
    static func sendTextMessage(localMessage: LocalMessage, text: String) {
        localMessage.type = SendChatTypeEnum.text.rawValue
        localMessage.message = text
        sendMessage(localMessage: localMessage)
    }
}
