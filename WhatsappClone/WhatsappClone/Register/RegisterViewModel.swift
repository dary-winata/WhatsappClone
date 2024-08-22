//
//  RegisterViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 22/08/24.
//

import Foundation

protocol RegisterViewModelProtocol: AnyObject {
    var delegate: RegisterViewModelDelegate? { get set }
    func onViewDidLoad()
}

protocol RegisterViewModelDelegate: AnyObject {
    func setupView()
}

class RegisterViewModel: RegisterViewModelProtocol {
    weak var delegate: RegisterViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
}
