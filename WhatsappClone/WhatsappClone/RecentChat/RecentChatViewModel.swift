//
//  RecentChatViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import Foundation

protocol RecentChatViewModelDelegate: AnyObject {
    func setupView()
}

protocol RecentChatViewModelProtocol: AnyObject {
    var delegate: RecentChatViewModelDelegate? {get set}
    func onViewDidLoad()
}

class RecentChatViewModel: RecentChatViewModelProtocol {
    var delegate: (any RecentChatViewModelDelegate)?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
}
