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
    
    func saveRecentChat(_ recentChat: RecentMessageModel) {
        do {
            try FirebaseHelper.FirebaseReference(.Recent).document(recentChat.id).setData(from: recentChat)
        } catch {
            print("Error save recent chat ", error.localizedDescription)
        }
    }
}
