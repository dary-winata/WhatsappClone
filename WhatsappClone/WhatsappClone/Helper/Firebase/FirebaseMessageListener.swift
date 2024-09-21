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
    
    var newChatListener: ListenerRegistration!
    
    private init() {}
    
    // Mark: Listen to new chat
    func listenForNewChat(chatId: String, receiveId: String, lastMessageDate: Date) {
        newChatListener = FirebaseHelper.FirebaseReference(.Message).document(receiveId).collection(chatId).whereField(keyDate, isGreaterThan: lastMessageDate).addSnapshotListener { snapshot, err in
            guard let snapshot else {
                return
            }
            
            for change in snapshot.documentChanges {
                if change.type == .added {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let message):
                        if let message {
                            if message.senderId != FirebaseHelper.getCurrentId {
                                DBManager.shared.saveToRealm(message)
                            }
                        } else {
                            print("message not exist")
                        }
                    case .failure(let err):
                        print("error decoding message: \(err)")
                    }
                }
            }
        }
    }
    
    // Mark: listen to update chat
    func listenForReadStatusChat(chatId: String, receiveId: String, completion: @escaping (LocalMessage) -> Void) {
        FirebaseHelper.FirebaseReference(.Message).document(receiveId).collection(chatId).addSnapshotListener { snapshot, err in
            guard let snapshot else {return}
            
            for change in snapshot.documentChanges {
                if change.type == .modified {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let message):
                        if let message {
                            completion(message)
                        }
                    case .failure(let err):
                        print("error decode to local message: \(err.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // Mark: Save, Update, Delete Message
    func saveMessage(_ message: LocalMessage, memberId: String) {
        do {
            try FirebaseHelper.FirebaseReference(.Message)
                .document(memberId).collection(message.chatRoomId)
                .document(message.id)
                .setData(from: message)
        } catch {
            print("error adding to firebase: ", error.localizedDescription)
        }
    }
    
    func updateMessageReadStatus(_ message: LocalMessage, membersId: [String]) {
        let editedMessage: [String: Any] = [keyReadDate: Date(), keyStatus: "read"]
        for id in membersId {
            FirebaseHelper.FirebaseReference(.Message).document(id).collection(message.chatRoomId).document(message.id).updateData(editedMessage)
        }
    }
    
    // Mark: Fetch old message and save to realmdb
    func fetchOldChat(chatId: String, receiverId: String) {
        FirebaseHelper.FirebaseReference(.Message).document(receiverId).collection(chatId).getDocuments { snapshot, err in
            guard let documents = snapshot?.documents else {
                print("no message found in firebase")
                return
            }
            
            var messages = documents.compactMap { query in
                return try? query.data(as: LocalMessage.self)
            }
            
            messages.sort(by: {$0.date < $1.date})
            
            for message in messages {
                DBManager.shared.saveToRealm(message)
            }
        }
    }
}
