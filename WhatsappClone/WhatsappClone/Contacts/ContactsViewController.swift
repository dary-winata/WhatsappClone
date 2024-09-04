//
//  ContactsViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 24/08/24.
//

import UIKit

class ContactsViewController: UIViewController {
    private lazy var contactListCell: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: "contact_list")
        
        return tableView
    }()
    
    private lazy var searchBarController: UISearchController = {
        let searchVC: UISearchController = UISearchController(searchResultsController: nil)
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search Contact"
        searchVC.searchResultsUpdater = self
        
        return searchVC
    }()
    
    private lazy var refresherController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        
        return refresh
    }()
    
    let viewModel: ContactsViewModel
    
    init(viewModel: ContactsViewModel) {
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

private extension ContactsViewController {
    
}

extension ContactsViewController: ContactsViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(contactListCell)
        
        NSLayoutConstraint.activate([
            contactListCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactListCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactListCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactListCell.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSearchView() {
        contactListCell.tableHeaderView = searchBarController.searchBar
//        self.navigationItem.searchController = searchBarController
//        navigationItem.hidesSearchBarWhenScrolling = false
        contactListCell.refreshControl = refresherController
        definesPresentationContext = true
    }
    
    func reloadCell() {
        self.contactListCell.reloadData()
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getContactData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView.dequeueReusableCell(withIdentifier: "contact_list", for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        
        table.setupData(viewModel.getContactData()[indexPath.row])
        
        return table
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refresherController.isRefreshing {
            viewModel.setupListCell()
            refresherController.endRefreshing()
        }
    }
}

extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchFiltered(searchController.searchBar.text ?? "")
        reloadCell()
    }
}
