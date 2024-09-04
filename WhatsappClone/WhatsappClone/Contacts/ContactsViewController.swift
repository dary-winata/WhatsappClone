//
//  ContactsViewController.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 24/08/24.
//

import UIKit

class ContactsViewController: UIViewController {
    
//    private lazy var searchTextField: UISearchTextField = {
//        let searchTF: UISearchTextField = UISearchTextField(frame: .zero)
//        searchTF.placeholder = "Search"
//        searchTF.translatesAutoresizingMaskIntoConstraints = false
//        
//        return searchTF
//    }()
    
    private lazy var contactListCell: UICollectionView = {
        let cellFlow: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        cellFlow.minimumLineSpacing = 16
        let cellView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: cellFlow)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.dataSource = self
        cellView.delegate = self
        cellView.register(ContactListCell.self, forCellWithReuseIdentifier: "contact_list")
        
        return cellView
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
        
        view.addSubview(contactListCell)
        
        NSLayoutConstraint.activate([
            contactListCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactListCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactListCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactListCell.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ContactsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = contactListCell.dequeueReusableCell(withReuseIdentifier: "contact_list", for: indexPath) as? ContactListCell else {
            return UICollectionViewCell()
        }
        
//        cell.setupData(viewModel.getContactData()[indexPath.row])
        cell.setupData(ContactListCellModel(avatar: "", username: "Suparman", status: "Baik"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: ContactListCell.getHeight())
    }
}
