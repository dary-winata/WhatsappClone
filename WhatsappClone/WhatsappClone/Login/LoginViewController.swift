//
//  LoginViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 21/08/24.
//

import ProgressHUD
import UIKit

class LoginViewController: UIViewController {
    
    private lazy var loginLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "Login"
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
    
    private lazy var forgetPasswordButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 5, green: 97, blue: 98, alpha: 1)
        btn.setTitle("Forgot Password", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(redMax: 4, greenMax: 73, blueMax: 73, alphaMax: 1), for: .normal)
        btn.addTarget(self, action: #selector(forgetPasswordButtonDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var loginButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 5, green: 97, blue: 98, alpha: 1)
        btn.setTitle("Login", for: .normal)
        btn.layer.cornerRadius = 30
        btn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        btn.backgroundColor = UIColor(redMax: 4, greenMax: 73, blueMax: 73, alphaMax: 1)
        btn.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var registerLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.text = "Don’t have and account?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 5, green: 97, blue: 98, alpha: 1)
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(redMax: 4, greenMax: 73, blueMax: 73, alphaMax: 1), for: .normal)
        btn.addTarget(self, action: #selector(registerButtonDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var stackRegisterView: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let viewModel: LoginViewModelProtocol
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
}

private extension LoginViewController {
    @objc
    func forgetPasswordButtonDidTapped() {
        if let email = usernameTextField.text {
            viewModel.onResetPasswordButtonDidTapped(email: email)
        } else {
            showProgressHudValue(with: "Please fill username", isSuccess: false)
        }
    }
    
    @objc
    func loginButtonDidTapped() {
        if let email = usernameTextField.text, let password = passwordTextField.text {
            viewModel.onLoginButtonDidTapped(email: email, password: password)
        } else {
            showProgressHudValue(with: "Please fill all the blank coloum", isSuccess: false)
        }
    }
    
    @objc
    func registerButtonDidTapped() {
        let registerViewModel: RegisterViewModel = RegisterViewModel()
        let registerViewController: RegisterViewController = RegisterViewController(viewModel: registerViewModel)
        self.navigationController?.setViewControllers([registerViewController], animated: true)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func setupView() {
        view.backgroundColor = UIColor(redMax: 235, greenMax: 235, blueMax: 235, alphaMax: 1)
        
        let separatorLoginToRegister: UIView = UIView(frame: .zero)
        separatorLoginToRegister.backgroundColor = .clear
        separatorLoginToRegister.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgetPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(separatorLoginToRegister)
        view.addSubview(stackRegisterView)
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            usernameTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            forgetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            loginButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            stackRegisterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            stackRegisterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            separatorLoginToRegister.topAnchor.constraint(lessThanOrEqualTo: loginButton.bottomAnchor),
            separatorLoginToRegister.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLoginToRegister.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorLoginToRegister.bottomAnchor.constraint(lessThanOrEqualTo: stackRegisterView.topAnchor)
        ])
        
        stackRegisterView.addArrangedSubview(registerLabel)
        stackRegisterView.addArrangedSubview(registerButton)
    }
    
    func showProgressHudValue(with text: String, isSuccess: Bool) {
        if isSuccess {
            ProgressHUD.success(text)
        } else {
            ProgressHUD.failed(text)
        }
    }
    
    func navigateToMainScreen() {
        
    }
}
