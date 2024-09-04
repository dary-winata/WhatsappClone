//
//  ContactsViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 25/08/24.
//

import Foundation
import UIKit

protocol ContactsViewModelDelegate: AnyObject {
    func setupView()
    func setupSearchView()
    func reloadCell()
}

protocol ContactsViewModelProtocol: AnyObject {
    var delegate: ContactsViewModelDelegate? {get set}
    func onViewDidLoad()
    func updateSearchFiltered(_ text: String)
    func getContactData() -> [ContactListCellModel]
    func setupListCell()
}

class ContactsViewModel: ContactsViewModelProtocol {
    weak var delegate: ContactsViewModelDelegate?
    
    private var contactList: [ContactListCellModel] = []
    
    private var filteredList: [ContactListCellModel] = []
    
    func onViewDidLoad() {
        delegate?.setupView()
        setupListCell()
        delegate?.setupSearchView()
    }
    
    func getContactData() -> [ContactListCellModel] {
        return filteredList
    }
    
    func updateSearchFiltered(_ text: String) {
        if text == "" {
            filteredList = contactList
        } else {
            filteredList = contactList.filter({$0.username.lowercased().contains(text)})
        }
    }
    
    func setupListCell() {
        FirebaseUserListener.shared.getAllUserFromFirestore { users in
            self.userModelToContactListCellModel(users)
            
            self.delegate?.reloadCell()
        }
    }
}

private extension ContactsViewModel {
    
    func userModelToContactListCellModel(_ users: [UserModel]) {
        var contactList: [ContactListCellModel] = []
        
        for user in users {
            let contact: ContactListCellModel = ContactListCellModel(avatar: user.avatar,
                                                                     username: user.username,
                                                                     status: user.status)
            contactList.append(contact)
        }
        
        self.contactList = contactList
        self.filteredList = contactList
    }
}
