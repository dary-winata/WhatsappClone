//
//  LoginViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 21/08/24.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    var delegate: LoginViewModelDelegate? { get set }
    func onViewDidLoad()
}

protocol LoginViewModelDelegate: AnyObject {
    func setupView()
}

class LoginViewModel: LoginViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
}
