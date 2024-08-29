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
}

protocol SettingsViewModelProtocol: AnyObject {
    var delegate: SettingsViewModelDelegate? {get set}
    func onViewDidLoad()
}

class SettingsViewModel: SettingsViewModelProtocol {
    var delegate: SettingsViewModelDelegate?
    
    private var userData: UserModel?
    
    func onViewDidLoad() {
        delegate?.setupView()
        fetchCurrentUserData()
    }
}

private extension SettingsViewModel {
    func fetchCurrentUserData() {
        guard let user = FirebaseHelper.getCurrentUser else {return}
        
        delegate?.setupUserView(username: user.username, status: user.status)
    }
}
