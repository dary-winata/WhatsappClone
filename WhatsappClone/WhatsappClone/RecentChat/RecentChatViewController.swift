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
    
    private lazy var refreshUI: UIRefreshControl = {
        let refresh: UIRefreshControl = UIRefreshControl()
        
        return refresh
    }()
    
    private lazy var searchVC: UISearchController = {
        let searchVC: UISearchController = UISearchController(nibName: nil, bundle: nil)
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search Chat"
        searchVC.searchResultsUpdater = self
        
        return searchVC
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
        
        setupSearchView()
    }
    
    func setupSearchView() {
        recentChatTableView.tableHeaderView = searchVC.searchBar
        recentChatTableView.refreshControl = refreshUI
        definesPresentationContext = true
    }
    
    func navigateToChatRoom(roomId: String, recieverUser: UserModel) {
        let chatVM: ChatsViewModel = ChatsViewModel(messageModel: MessageModel(chatId: roomId, recipientId: recieverUser.id, recipientName: recieverUser.username, recipientAvatar: recieverUser.avatar))
        let chatVC: ChatsViewController = ChatsViewController(viewModel: chatVM)
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension RecentChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getRecentData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recent_cell", for: indexPath) as? RecentChatCell else {
            return UITableViewCell()
        }
        
        cell.setupModel(viewModel.getRecentData()[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableViewDidSelectDidTapped(indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshUI.isRefreshing {
            viewModel.fetchData()
            refreshUI.endRefreshing()
        }
    }
    
    func reloadTable() {
        self.recentChatTableView.reloadData()
    }
}

extension RecentChatViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.findSearchMessage(searchController.searchBar.text ?? "")
        reloadTable()
    }
}
