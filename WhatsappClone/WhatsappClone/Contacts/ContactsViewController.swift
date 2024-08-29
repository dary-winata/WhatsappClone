//
//  ContactsViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 24/08/24.
//

import UIKit

class ContactsViewController: UIViewController {
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTF: UISearchTextField = UISearchTextField(frame: .zero)
        searchTF.placeholder = "Search"
        searchTF.translatesAutoresizingMaskIntoConstraints = false
        
        return searchTF
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

extension ContactsViewController: ContactsViewModelDelegate {
    func setupView() {
        view.backgroundColor = .white
        
        
    }
}
