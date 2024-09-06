//
//  RecentChatViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import Foundation

protocol RecentChatViewModelDelegate: AnyObject {
    func setupView()
    func reloadTable()
}

protocol RecentChatViewModelProtocol: AnyObject {
    var delegate: RecentChatViewModelDelegate? {get set}
    func onViewDidLoad()
    func getRecentData() -> [RecentMessageModel]
    func fetchData()
    func findSearchMessage(_ text: String)
}

class RecentChatViewModel: RecentChatViewModelProtocol {
    var delegate: RecentChatViewModelDelegate?
    
    private var recentData: [RecentMessageModel] = []
    private var filteredData: [RecentMessageModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
        fetchData()
    }
    
    func fetchData() {
        FirebaseRecentChatListener.shared.downloadRecentChatDataFromFirestore { recentChats in
            self.recentData = recentChats
            self.filteredData = recentChats
            
            DispatchQueue.main.async {
                self.delegate?.reloadTable()
            }
        }
    }
    
    func getRecentData() -> [RecentMessageModel] {
        return filteredData
    }
    
    func findSearchMessage(_ text: String) {
        if text == "" {
            self.filteredData = recentData
        } else {
            print(text)
            let currentUser = FirebaseHelper.getCurrentUser?.username
            self.filteredData = recentData.filter({ recentMessage in
                if currentUser == recentMessage.recieverName {
                    return recentMessage.recieverName.lowercased().contains(text.lowercased()) || recentMessage.lastMessage.lowercased().contains(text.lowercased())
                } else {
                    return recentMessage.senderName.lowercased().contains(text.lowercased()) || recentMessage.lastMessage.lowercased().contains(text.lowercased())
                }
            })
        }
    }
}
