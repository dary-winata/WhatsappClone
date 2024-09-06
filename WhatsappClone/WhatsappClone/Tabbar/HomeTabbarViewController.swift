//
//  HomeTabbarViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 24/08/24.
//

import UIKit

class HomeTabbarViewController: UITabBarController {
    
    let viewModel: HomeTabbarViewModelProtocol
    
    init(viewModel: HomeTabbarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppeare()
    }
}

extension HomeTabbarViewController: HomeTabbarViewModelDelegate {
    func setupView() {
        let contactTabItem: UITabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "person.crop.circle"), tag: 0)
        let chatsTabItem: UITabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 1)
        let settingsTabItem: UITabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        let contactsVM: ContactsViewModel = ContactsViewModel()
        let contactsVC: ContactsViewController = ContactsViewController(viewModel: contactsVM)
        contactsVC.tabBarItem = contactTabItem
        
        let recentChatVM: RecentChatViewModel = RecentChatViewModel()
        let recentChatVC: RecentChatViewController = RecentChatViewController(viewModel: recentChatVM)
        recentChatVC.tabBarItem = chatsTabItem
        
        let settingsVM: SettingsViewModel = SettingsViewModel()
        let settingsVC: SettingsViewController = SettingsViewController(viewModel: settingsVM)
        settingsVC.tabBarItem = settingsTabItem
        
        tabBar.backgroundColor = .white
        viewControllers = [contactsVC, recentChatVC, settingsVC]
        navigationItem.title = contactsVC.tabBarItem.title
        delegate = self
    }
}

extension HomeTabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let currentView = selectedViewController?.view, let navigatedView = viewController.view else {
            return false
        }
        
        if currentView != navigatedView {
            UIView.transition(from: currentView, to: navigatedView, duration: 0.3, options: [.transitionCrossDissolve])
            navigationItem.title = viewController.tabBarItem.title
        }
        
        return true
    }
}
