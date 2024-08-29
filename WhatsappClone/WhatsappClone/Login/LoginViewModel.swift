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
    func onResetPasswordButtonDidTapped(email: String)
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
                self.delegate?.navigateToMainScreen()
            } else {
                self.delegate?.showProgressHudValue(with: "error login: \(error?.localizedDescription ?? "")", isSuccess: false)
            }
        }
    }
    
    func onResetPasswordButtonDidTapped(email: String) {
        FirebaseUserListener.shared.resetPassword(email: email) { error in
            if error == nil {
                self.delegate?.showProgressHudValue(with: "Success reset password", isSuccess: true)
            } else {
                self.delegate?.showProgressHudValue(with: "Error reset password: \(error?.localizedDescription ?? "")", isSuccess: false)
            }
        }
    }
}
