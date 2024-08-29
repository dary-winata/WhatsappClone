//
//  ContactsViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 25/08/24.
//

import Foundation

protocol ContactsViewModelDelegate: AnyObject {
    func setupView()
}

protocol ContactsViewModelProtocol: AnyObject {
    var delegate: ContactsViewModelDelegate? {get set}
    func onViewDidLoad()
}

class ContactsViewModel: ContactsViewModelProtocol {
    weak var delegate: ContactsViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
}
