//
//  SettingsViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 25/08/24.
//

import Foundation

protocol SettingsViewModelDelegate: AnyObject {
    func setupView()
}

protocol SettingsViewModelProtocol: AnyObject {
    var delegate: SettingsViewModelDelegate? {get set}
    func onViewDidLoad()
}

class SettingsViewModel: SettingsViewModelProtocol {
    var delegate: SettingsViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
}
