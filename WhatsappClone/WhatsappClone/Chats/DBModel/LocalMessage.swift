//
//  LocalMessage.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 07/09/24.
//

import Foundation
import RealmSwift

class LocalMessage: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var chatRoomId: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var senderName: String = ""
    @objc dynamic var senderId: String = ""
    @objc dynamic var senderInitial: String = ""
    @objc dynamic var readDate: Date = Date()
    @objc dynamic var type: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var message: String = ""
    @objc dynamic var photoUrl: String = ""
    @objc dynamic var videoUrl: String = ""
    @objc dynamic var audioUrl: String = ""
    @objc dynamic var audioDuration: Double = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
