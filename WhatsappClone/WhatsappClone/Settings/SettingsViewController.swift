//
//  SettingsViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 24/08/24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var userView: SettingsUserView = {
        let user: SettingsUserView = SettingsUserView(frame: .zero)
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editUserViewDidOnTapped))
        user.addGestureRecognizer(gesture)
        user.translatesAutoresizingMaskIntoConstraints = false
        
        return user
    }()
    
    private lazy var shareLogoutView: ShareLogoutUserView = {
        let share: ShareLogoutUserView = ShareLogoutUserView(frame: .zero)
        share.translatesAutoresizingMaskIntoConstraints = false
        
        return share
    }()
    
    private lazy var logoutButton: UIButton = {
        let btn: UIButton = UIButton(frame: .zero)
        btn.setTitle("Logout", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Mullish", size: 16)
        btn.backgroundColor = .clear
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(logoutButtonDidTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    let viewModel: SettingsViewModelProtocol
    
    init(viewModel: SettingsViewModelProtocol) {
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
        viewModel.fetchCurrentUserData()
    }
}

private extension SettingsViewController {
    @objc
    func editUserViewDidOnTapped() {
        let editVM: EditProfileUserViewModel = EditProfileUserViewModel()
        let editVC: EditProfileUserViewController = EditProfileUserViewController(viewModel: editVM)
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    func logoutButtonDidTapped() {
        viewModel.onLogoutButtonDidTapped()
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func setupView() {
        self.view.backgroundColor = UIColor(redMax: 235, greenMax: 235, blueMax: 235, alphaMax: 1)
        
        let logoutView: UIView = UIView(frame: .zero)
        logoutView.translatesAutoresizingMaskIntoConstraints = false
        logoutView.backgroundColor = .white
        
        view.addSubview(userView)
        view.addSubview(shareLogoutView)
        view.addSubview(logoutView)
        
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            shareLogoutView.topAnchor.constraint(equalTo: userView.bottomAnchor, constant: 25),
            shareLogoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shareLogoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            logoutView.topAnchor.constraint(equalTo: shareLogoutView.bottomAnchor),
            logoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoutView.heightAnchor.constraint(equalToConstant: 47),
        ])
        
        logoutView.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: logoutView.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: logoutView.centerYAnchor)
        ])
    }
    
    func setupUserView(image: UIImage?,username: String, status: String) {
        userView.setupModel(image: image, username: username, status: status)
    }
    
    func navigateToLoginView() {
        let loginVM: LoginViewModel = LoginViewModel()
        let loginVC: LoginViewController = LoginViewController(viewModel: loginVM)
        
        navigationController?.setViewControllers([loginVC], animated: true)
    }
}
