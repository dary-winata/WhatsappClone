//
//  RecentChatViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 05/09/24.
//

import UIKit

class RecentChatViewController: UIViewController {
    
    private lazy var recentChatTableView: UITableView = {
        let table: UITableView = UITableView(frame: .zero)
        table.dataSource = self
        table.delegate = self
        table.register(RecentChatCell.self, forCellReuseIdentifier: "recent_cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()

    let viewModel: RecentChatViewModelProtocol
    
    init(viewModel: RecentChatViewModelProtocol) {
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

extension RecentChatViewController: RecentChatViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(recentChatTableView)
        
        NSLayoutConstraint.activate([
            recentChatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recentChatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentChatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentChatTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RecentChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recent_cell", for: indexPath) as? RecentChatCell else {
            return UITableViewCell()
        }
        
        cell.setupModel(RecentMessageModel(chatRoomId: "123", senderName: "Testing", lastMessage: "maka3", unreadCounter: 0))
        
        return cell
    }
}
