//
//  ProfileViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func setupView()
}

protocol ProfileViewModelProtocol: AnyObject {
    var delegate: ProfileViewModelDelegate? {get set}
    func onViewDidLoad()
}

class ProfileViewModel: ProfileViewModelProtocol {
    var delegate: (any ProfileViewModelDelegate)?
    
    private var user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    func onViewDidLoad() {
        self.delegate?.setupView()
    }
}
