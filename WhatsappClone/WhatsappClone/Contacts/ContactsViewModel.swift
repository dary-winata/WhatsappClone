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
    func reloadCell()
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
        FirebaseUserListener.shared.getAllUserFromFirestore { users in
            self.userModelToContactListCellModel(users)
            
            self.delegate?.reloadCell()
        }
    }
    
    func userModelToContactListCellModel(_ users: [UserModel]) {
        var contactList: [ContactListCellModel] = []
        
        for user in users {
            let contact: ContactListCellModel = ContactListCellModel(avatar: user.avatar,
                                                                     username: user.username,
                                                                     status: user.status)
            contactList.append(contact)
        }
        
        self.contactList = contactList
    }
}
