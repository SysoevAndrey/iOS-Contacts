//
//  ContactListViewController.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 23.02.2023.
//

import UIKit

class ContactListViewController: UIViewController {
    // Layout
    
    private let contactsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Контакты"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    private let sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Sort"), for: .normal)
        return button
    }()
    private let filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Filter"), for: .normal)
        return button
    }()
    
    // Properties
    
    private let contactService: ContactLoading = ContactService()
    private var contacts = [Contact]()
    
    // Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        
        contactService.loadContacts { [weak self] loadedContacts in
            self?.contacts = loadedContacts
        }
    }
}

private extension ContactListViewController {
    func setupContent() {
        view.backgroundColor = .fullBlack
        view.addSubview(contactsLabel)
        view.addSubview(sortButton)
        view.addSubview(filterButton)
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
        
        NSLayoutConstraint.activate(
            contactsLabelConstraints +
            sortButtonConstraints +
            filterButtonConstraints
        )
    }
}

