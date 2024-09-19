//
//  FirebaseTypingListener.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 19/09/24.
//

import Firebase
import Foundation

class FirebaseTypingListener {
    static let shared: FirebaseTypingListener = FirebaseTypingListener()
    
    var typingListener: ListenerRegistration!
    
    private init() {}
    
    func setListenerForTypingStatus(chatRoomId: String, completion: @escaping (Bool) -> Void) {
        typingListener = FirebaseHelper.FirebaseReference(.Typing).document(chatRoomId).addSnapshotListener { snapshot, err in
            guard let snapshot else { return }
            
            if snapshot.exists {
                for data in snapshot.data()! {
                    if data.key != FirebaseHelper.getCurrentId {
                        completion(data.value as? Bool ?? false)
                    }
                }
            } else {
                completion(false)
                FirebaseHelper.FirebaseReference(.Typing).document(chatRoomId).setData([FirebaseHelper.getCurrentId : false])
            }
        }
    }
    
    func saveTypingStatus(typingStatus: Bool, chatRoomId: String) {
        FirebaseHelper.FirebaseReference(.Typing).document(chatRoomId).updateData([FirebaseHelper.getCurrentId:typingStatus])
    }
    
    func removeTypingListener() {
        self.typingListener.remove()
    }
}
