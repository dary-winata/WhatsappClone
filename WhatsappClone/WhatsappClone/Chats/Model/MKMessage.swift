//
//  MKMessage.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 07/09/24.
//

import Foundation
import MessageKit

class MKMessage: NSObject, MessageType {
    var sender: SenderType {return mkSender}
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    var mkSender: MKSender
    var senderInitial: String
    
    var status: String
    var readDate: Date
    var isIncoming: Bool
    
    init(message: LocalMessage) {
        self.messageId = message.id
        self.kind = MessageKind.text(message.message)
        self.sentDate = message.date
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.senderInitial = message.senderInitial
        self.status = message.status
        self.readDate = message.readDate
        self.isIncoming = FirebaseHelper.getCurrentId != mkSender.senderId
        
//        switch message.type {
//            
//        }
    }
}
