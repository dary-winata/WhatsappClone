//
//  FirebaseRecentChatHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 06/09/24.
//

import Foundation
import Firebase

class FirebaseRecentChatHelper {
    static let shared = FirebaseRecentChatHelper()
    
    private init() {}
    
    func startChat(user1: UserModel, user2: UserModel) -> String {
        let roomId = getChatRoomId(user1Id: user1.id, user2Id: user2.id)
        
        print("creating room id: ", roomId)
        
        createRecentChatItem(roomId: roomId, users: [user1, user2])
        
        return roomId
    }
    
    func restartChat(chatRoomId: String, membersIds: [String]) {
        FirebaseUserListener.shared.getMultipleUserFromFirestorById(membersIds) { user in
            if user.count > 0 {
                FirebaseRecentChatHelper.shared.createRecentChatItem(roomId: chatRoomId, users: user)
            }
        }
    }
    
    func createRecentChatItem(roomId: String, users: [UserModel]) {
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
                memberIdsToCreateRecentChat = self.removeUserWhoHasRecentChat(snapshot: snapshotQuery, memberIds: memberIdsToCreateRecentChat)
            }
            
            guard let currentUser = FirebaseHelper.getCurrentUser else {return}
            for id in memberIdsToCreateRecentChat {
                print("Creating recent chat for id \(id)")
                let senderUser = id == currentUser.id ? currentUser : self.getRecieverUser(user: users)
                
                let recieverUser = id != currentUser.id ? currentUser : self.getRecieverUser(user: users)
                
                let recentChat = RecentMessageModel(id: UUID().uuidString, chatRoomId: roomId, senderId: senderUser.id, senderName: senderUser.username, recieverId: recieverUser.id, recieverName: recieverUser.username, date: Date(), lastMessage: "", avatar: recieverUser.avatar, unreadCounter: 0)
                
                // store to firebase
                FirebaseRecentChatListener.shared.saveRecentChat(recentChat)
            }
        }
    }
    
    func getChatRoomId(user1Id: String, user2Id: String) -> String {
        let value = user1Id.compare(user2Id).rawValue
        return value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    }
    
    func removeUserWhoHasRecentChat(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
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
    
    func getRecieverUser(user: [UserModel]) -> UserModel {
        var allUsers = user
        
        guard let currentUser = FirebaseHelper.getCurrentUser else {return allUsers.first!}
//        guard let currentUserIndex = allUsers.firstIndex(of: currentUser) else {return allUsers.first!}
        allUsers.remove(at: allUsers.firstIndex(of: currentUser)!)
        
        return allUsers.first!
    }
    
    // Mark: - Update recent chat
    func updateRecentChat(chatRoomId: String, lastMessage: String) {
        // get recent chat on firebase
        FirebaseHelper.FirebaseReference(.Recent).whereField(keyChatRoomId, isEqualTo: chatRoomId).getDocuments { snapshot, err in
            guard let snapshot else {return}
            
            let result = snapshot.documents.compactMap { query in
                try? query.data(as: RecentMessageModel.self)
            }
            
            for data in result {
                // update coutner and recent chat at firebase
                self.updateRecentChatToFirebase(lastMessage: lastMessage, recentChat: data)
            }
        }
    }
    
    private func updateRecentChatToFirebase(lastMessage: String, recentChat: RecentMessageModel) {
        var tempRecent = recentChat
        
        if tempRecent.senderId != FirebaseHelper.getCurrentId {
            tempRecent.unreadCounter += 1
        }
        
        tempRecent.lastMessage = lastMessage
        tempRecent.date = Date()
        
        FirebaseRecentChatListener.shared.saveRecentChat(tempRecent)
    }
    
    // Mark: Reset recent chat counter
    func resetRecentChatCounter(chatRooomId: String) {
        FirebaseHelper.FirebaseReference(.Recent).whereField(keyChatRoomId, isEqualTo: chatRooomId).whereField(keySenderId, isEqualTo: FirebaseHelper.getCurrentId).getDocuments { snapshot, err in
            guard let snapshot else {return}
            
            let snapshotResult = snapshot.documents.compactMap { query in
                try? query.data(as: RecentMessageModel.self)
            }
            
            if snapshotResult.count > 0 {
                if let firstSnapshot = snapshotResult.first {
                    self.savedRecentChatCounter(recentChat: firstSnapshot)
                }
            }
        }
    }
    
    private func savedRecentChatCounter(recentChat: RecentMessageModel) {
        var tempRecent = recentChat
        tempRecent.unreadCounter = 0
        FirebaseRecentChatListener.shared.saveRecentChat(tempRecent)
    }
}
