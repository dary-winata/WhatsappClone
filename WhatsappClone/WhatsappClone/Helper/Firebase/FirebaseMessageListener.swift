//
//  FirebaseMessageListener.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 08/09/24.
//

import Firebase
import Foundation

class FirebaseMessageListener {
    static let shared = FirebaseMessageListener()
    
    private init() {}
    
    // Mark: Save, Update, Delete Message
    func saveMessage(_ message: LocalMessage, memberId: String) {
        do {
            try FirebaseHelper.FirebaseReference(.Message)
                .document(memberId).collection(message.chatRoomID)
                .document(message.id)
                .setData(from: message)
        } catch {
            print("error adding to firebase: ", error.localizedDescription)
        }
    }
}
