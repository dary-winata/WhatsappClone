//
//  FirebaseRecentChatListener.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 06/09/24.
//

import Foundation

class FirebaseRecentChatListener {
    static let shared: FirebaseRecentChatListener = FirebaseRecentChatListener()
    
    private init () {}
    
    //Mark: - Download Recent Chat
    
    func downloadRecentChatDataFromFirestore(completion: @escaping (_ recentChats: [RecentMessageModel]) -> Void) {
        FirebaseHelper.FirebaseReference(.Recent).whereField(keySenderId, isEqualTo: FirebaseHelper.getCurrentId).addSnapshotListener { snapshot, error in
            var recentChat: [RecentMessageModel] = []
            
            guard let documents = snapshot?.documents else {
                print("no documents")
                completion(recentChat)
                return
            }
            
            let recentChats = documents.compactMap { snap in
                return try? snap.data(as: RecentMessageModel.self)
            }
            
            for chat in recentChats {
                if !chat.lastMessage.isEmpty {
                    recentChat.append(chat)
                }
            }
            
            completion(recentChat)
        }
    }
    
    func saveRecentChat(_ recentChat: RecentMessageModel) {
        do {
            try FirebaseHelper.FirebaseReference(.Recent).document(recentChat.id).setData(from: recentChat)
        } catch {
            print("Error save recent chat ", error.localizedDescription)
        }
    }
}
