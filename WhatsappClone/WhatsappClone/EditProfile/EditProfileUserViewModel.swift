//
//  EditProfileUserViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 30/08/24.
//

import Foundation

protocol EditProfileUserViewModelDelegate: AnyObject {
    func setupView()
}

protocol EditProfileUserViewModelProtocol: AnyObject {
    var delegate: EditProfileUserViewModelDelegate? {get set}
    func onViewDidLoad()
}

class EditProfileUserViewModel: EditProfileUserViewModelProtocol {
    weak var delegate: EditProfileUserViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
}
