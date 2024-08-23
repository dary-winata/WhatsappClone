//
//  RegisterViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 22/08/24.
//

import ProgressHUD
import UIKit

class RegisterViewController: UIViewController {
    
    private lazy var registerTitleLable: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "Register"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField: UITextField = UITextField(frame: .zero)
        textField.placeholder = "username"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField: UITextField = UITextField(frame: .zero)
        textField.placeholder = "password"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var repeatPasswordTextField: UITextField = {
        let textField: UITextField = UITextField(frame: .zero)
        textField.placeholder = "repeat password"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 5, green: 97, blue: 98, alpha: 1)
        btn.setTitle("Register", for: .normal)
        btn.layer.cornerRadius = 30
        btn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        btn.backgroundColor = UIColor(redMax: 4, greenMax: 73, blueMax: 73, alphaMax: 1)
        btn.addTarget(self, action: #selector(registerButtonDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var loginLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "Have an account?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 5, green: 97, blue: 98, alpha: 1)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(redMax: 4, greenMax: 73, blueMax: 73, alphaMax: 1), for: .normal)
        btn.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let viewModel: RegisterViewModelProtocol
    
    init(viewModel: RegisterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

private extension RegisterViewController {
    @objc
    func loginButtonDidTapped() {
        let loginVM: LoginViewModel = LoginViewModel()
        let loginVC: LoginViewController = LoginViewController(viewModel: loginVM)
        self.navigationController?.setViewControllers([loginVC], animated: true)
    }
    
    @objc
    func registerButtonDidTapped() {
        if let email = usernameTextField.text, let password = passwordTextField.text, let passwordRepeat = repeatPasswordTextField.text {
            viewModel.onRegisterButtonDidTapped(email: email, password: password, repeatPassword: passwordRepeat)
        } else {
            showProgressHudValue(with: "Please fill all the blank coloum", isSuccess: false)
        }
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func setupView() {
        view.backgroundColor = UIColor(redMax: 235, greenMax: 235, blueMax: 235, alphaMax: 1)
        
        let separatorRegisterToLogin: UIView = UIView(frame: .zero)
        separatorRegisterToLogin.backgroundColor = .clear
        separatorRegisterToLogin.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(registerTitleLable)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(registerButton)
        view.addSubview(separatorRegisterToLogin)
        view.addSubview(loginStackView)
        
        NSLayoutConstraint.activate([
            registerTitleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            registerTitleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registerTitleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            usernameTextField.topAnchor.constraint(equalTo: registerTitleLable.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            registerButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            
            separatorRegisterToLogin.topAnchor.constraint(equalTo: registerButton.bottomAnchor),
            separatorRegisterToLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorRegisterToLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorRegisterToLogin.bottomAnchor.constraint(equalTo: loginStackView.topAnchor)
        ])
        
        loginStackView.addArrangedSubview(loginLabel)
        loginStackView.addArrangedSubview(loginButton)
    }
    
    func showProgressHudValue(with text: String, isSuccess: Bool) {
        if isSuccess {
            ProgressHUD.success(text)
        } else {
            ProgressHUD.failed(text)
        }
    }
}
