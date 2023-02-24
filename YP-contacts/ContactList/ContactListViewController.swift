//
//  ContactListViewController.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 23.02.2023.
//

import UIKit

class ContactListViewController: UIViewController {
    // MARK: - Layout
    
    private let contactsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Контакты"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Sort"), for: .normal)
        return button
    }()
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Filter"), for: .normal)
        return button
    }()
    private let contactsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .fullBlack
        table.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    // MARK: - Properties
    
    private let contactService: ContactLoading = ContactService()
    private var contacts = [Contact]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTable.dataSource = self
        contactsTable.register(ContactListCell.self, forCellReuseIdentifier: ContactListCell.reuseIdentifier)
        
        setupContent()
        setupConstraints()
        
        contactService.loadContacts { [weak self] loadedContacts in
            self?.contacts = loadedContacts
            self?.contactsTable.reloadData()
        }
    }
    
    // MARK: - Overriden
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

private extension ContactListViewController {
    func setupContent() {
        view.backgroundColor = .fullBlack
        view.addSubview(contactsLabel)
        view.addSubview(sortButton)
        view.addSubview(filterButton)
        view.addSubview(contactsTable)
    }
    
    func setupConstraints() {
        let contactsLabelConstraints = [
            contactsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contactsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2)
        ]
        let sortButtonConstraints = [
            sortButton.centerYAnchor.constraint(equalTo: contactsLabel.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -16)
        ]
        let filterButtonConstraints = [
            filterButton.centerYAnchor.constraint(equalTo: contactsLabel.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        let contactsTableConstraints = [
            contactsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contactsTable.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 8),
            contactsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contactsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(
            contactsLabelConstraints +
            sortButtonConstraints +
            filterButtonConstraints +
            contactsTableConstraints
        )
    }
}

// MARK: - UITableViewDataSource

extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTable.dequeueReusableCell(withIdentifier: ContactListCell.reuseIdentifier, for: indexPath)
        
        guard let contactListCell = cell as? ContactListCell else {
            return UITableViewCell()
        }
        
        let contact = contacts[indexPath.row]
        contactListCell.configureCell(with: contact)
        
        return contactListCell
    }
}
