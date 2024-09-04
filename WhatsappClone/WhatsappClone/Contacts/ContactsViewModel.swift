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
    func getContactData() -> [ContactListCellModel]
}

class ContactsViewModel: ContactsViewModelProtocol {
    weak var delegate: ContactsViewModelDelegate?
    
    private var contactList: [ContactListCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
        setupListCell()
    }
    
    func getContactData() -> [ContactListCellModel] {
        return contactList
    }
}

private extension ContactsViewModel {
    func setupListCell() {
        
    }
}
