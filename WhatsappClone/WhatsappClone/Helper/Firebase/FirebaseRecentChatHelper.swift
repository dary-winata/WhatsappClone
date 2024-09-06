//
//  FirebaseRecentChatHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 06/09/24.
//

import Foundation
import Firebase

class FirebaseRecentChatHelper {
    static func startChat(user1: UserModel, user2: UserModel) -> String {
        let roomId = getChatRoomId(user1Id: user1.id, user2Id: user2.id)
        
        return roomId
    }
    
    static func createRecentChatItem(roomId: String, users: [UserModel]) {
        if users.isEmpty {
            return
        }
        
        var memberIdsToCreateRecentChat = [users.first!.id, users.last!.id]
        
        FirebaseHelper.FirebaseReference(.Recent).whereField(keyChatRoomId, isEqualTo: roomId).getDocuments { snapshotQuery, err in
            guard let snapshotQuery else {
                return
            }
            
            if !snapshotQuery.isEmpty {
                // Remove user who has recent chat
                memberIdsToCreateRecentChat = removeUserWhoHasRecentChat(snapshot: snapshotQuery, memberIds: memberIdsToCreateRecentChat)
            }
            
            guard let currentUser = FirebaseHelper.getCurrentUser else {return}
            for id in memberIdsToCreateRecentChat {
                let senderUser = id == currentUser.id ? currentUser : getRecieverUser(user: users)
                
                let recieverUser = id != currentUser.id ? currentUser : getRecieverUser(user: users)
                
                let recentChat = RecentMessageModel(id: UUID().uuidString, chatRoomId: roomId, senderId: senderUser.id, senderName: senderUser.username, recieverId: recieverUser.id, recieverName: recieverUser.username, date: Date(), lastMessage: "", avatar: recieverUser.avatar, unreadCounter: 0)
                
                // store to firebase
                FirebaseRecentChatListener.shared.saveRecentChat(recentChat)
            }
        }
    }
    
    static func getChatRoomId(user1Id: String, user2Id: String) -> String {
        let value = user1Id.compare(user2Id).rawValue
        return value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    }
    
    static func removeUserWhoHasRecentChat(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
        var membersIdsToCreateRecentChat = memberIds
        
        for data in snapshot.documents {
            let currentRecentData = data.data() as Dictionary
            
            if let currentUserId = currentRecentData[keySenderId] {
                let userId = currentUserId as! String
                if membersIdsToCreateRecentChat.contains(userId) {
                    guard let idx = membersIdsToCreateRecentChat.firstIndex(of: userId) else {continue}
                    membersIdsToCreateRecentChat.remove(at: idx)
                }
            }
        }
        
        return membersIdsToCreateRecentChat
    }
    
    static func getRecieverUser(user: [UserModel]) -> UserModel {
        var allUsers = user
        
        guard let currentUser = FirebaseHelper.getCurrentUser else {return allUsers.first!}
        allUsers.remove(at: allUsers.firstIndex(of: currentUser)!)
        
        return allUsers.first!
    }
}
