//
//  ProfileViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func setupView()
    func setupProfile(_ user: UserModel)
    func navigateToChat()
}

protocol ProfileViewModelProtocol: AnyObject {
    var delegate: ProfileViewModelDelegate? {get set}
    func onViewDidLoad()
    func getUser() -> UserModel
    func goToMessageViewDidTapped()
}

class ProfileViewModel: ProfileViewModelProtocol {
    var delegate: (any ProfileViewModelDelegate)?
    
    private var user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    func onViewDidLoad() {
        self.delegate?.setupView()
        delegate?.setupProfile(user)
    }
    
    func getUser() -> UserModel {
        return user
    }
    
    func goToMessageViewDidTapped() {
        guard let currentUser = FirebaseHelper.getCurrentUser else {return}
        let recieverUser = self.getUser()
        
        let recentChat = FirebaseRecentChatHelper.shared.startChat(user1: currentUser, user2: self.user)
        delegate?.navigateToChat()
    }
}
