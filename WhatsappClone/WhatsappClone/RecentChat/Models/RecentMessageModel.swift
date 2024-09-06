//
//  RecentMessageModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import Firebase
import Foundation

struct RecentMessageModel: Codable {
    var id: String = ""
    var chatRoomId: String = ""
    var senderId: String = ""
    var senderName: String = ""
    var recieverId: String = ""
    var recieverName: String = ""
    @ServerTimestamp var date: Date? = Date()
    var lastMessage: String = ""
    var avatar: String = ""
    var unreadCounter: Int = 0
}
