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
    func onRegisterButtonDidTapped(email: String, password: String, repeatPassword: String)
}

protocol RegisterViewModelDelegate: AnyObject {
    func setupView()
    func showProgressHudValue(with text: String, isSuccess: Bool)
}

class RegisterViewModel: RegisterViewModelProtocol {
    weak var delegate: RegisterViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func onRegisterButtonDidTapped(email: String, password: String, repeatPassword: String) {
        if password == repeatPassword {
            FirebaseUserListener.shared.registerUserWith(email: email, password: password) { error in
                if error != nil {
                    self.delegate?.showProgressHudValue(with: "Error Register User \(error?.localizedDescription ?? "")", isSuccess: false)
                } else {
                    self.delegate?.showProgressHudValue(with: "Success Register User", isSuccess: true)
                }
            }
        } else {
            self.delegate?.showProgressHudValue(with: "Password is not same", isSuccess: false)
        }
    }
}
