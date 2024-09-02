//
//  SettingsViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 25/08/24.
//

import Foundation

protocol SettingsViewModelDelegate: AnyObject {
    func setupView()
    func setupUserView(username: String, status: String)
    func navigateToLoginView()
}

protocol SettingsViewModelProtocol: AnyObject {
    var delegate: SettingsViewModelDelegate? {get set}
    func onViewDidLoad()
    func onLogoutButtonDidTapped()
    func fetchCurrentUserData()
}

class SettingsViewModel: SettingsViewModelProtocol {
    var delegate: SettingsViewModelDelegate?
    
    private var userData: UserModel?
    
    func onViewDidLoad() {
        delegate?.setupView()
        fetchCurrentUserData()
    }
    
    func onLogoutButtonDidTapped() {
        FirebaseUserListener.shared.logoutUser { error in
            if let error {
                print(error)
            } else {
                self.delegate?.navigateToLoginView()
            }
        }
    }
    
    func fetchCurrentUserData() {
        guard let user = FirebaseHelper.getCurrentUser else {return}
        
        delegate?.setupUserView(username: user.username, status: user.status)
    }
}
