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
    func onLoginButtonDidTapped(email: String, password: String)
}

protocol LoginViewModelDelegate: AnyObject {
    func setupView()
    func showProgressHudValue(with text: String, isSuccess: Bool)
    func navigateToMainScreen()
}

class LoginViewModel: LoginViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func onLoginButtonDidTapped(email: String, password: String) {
        FirebaseUserListener.shared.loginUser(email: email, password: password) { error, isEmailVerified in
            if error == nil {
                self.delegate?.showProgressHudValue(with: "Login Success", isSuccess: true)
            } else {
                self.delegate?.showProgressHudValue(with: "error login: \(error?.localizedDescription ?? "")", isSuccess: false)
            }
        }
    }
}
