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
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        return button
    }()
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Filter"), for: .normal)
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()
    private let contactsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .fullBlack
        table.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
        table.register(ContactListCell.self, forCellReuseIdentifier: ContactListCell.reuseIdentifier)
        return table
    }()
    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.text = "Таких контактов нет, выберите другие фильтры"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Properties
    
    private let contactService: ContactLoading = ContactService.shared
    private var contacts: [Contact] = [] {
        willSet {
            if newValue.isEmpty {
                emptyListLabel.isHidden = false
                contactsTable.isHidden = true
            } else {
                emptyListLabel.isHidden = true
                contactsTable.isHidden = false
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTable.dataSource = self
        contactsTable.delegate = self
        
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
    
    // MARK: - Methods
    
    @objc private func didTapSortButton() {
        let sortViewController = SortViewController()
        sortViewController.delegate = self
        present(sortViewController, animated: true)
    }
    
    @objc private func didTapFilterButton() {
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        present(filterViewController, animated: true)
    }
}

private extension ContactListViewController {
    func setupContent() {
        view.backgroundColor = .fullBlack
        view.addSubview(contactsLabel)
        view.addSubview(sortButton)
        view.addSubview(filterButton)
        view.addSubview(contactsTable)
        view.addSubview(emptyListLabel)
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
        let emptyListLabelConstraints = [
            emptyListLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyListLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emptyListLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(
            contactsLabelConstraints +
            sortButtonConstraints +
            filterButtonConstraints +
            contactsTableConstraints +
            emptyListLabelConstraints
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

// MARK: - UITableViewDelegate

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let swipeContainerView = tableView.subviews.first(where: { String(describing: type(of: $0)) == "_UITableViewCellSwipeContainerView" }) {
            if let swipeActionPullView = swipeContainerView.subviews.first, String(describing: type(of: swipeActionPullView)) == "UISwipeActionPullView" {
                swipeActionPullView.layer.cornerRadius = 24
                swipeActionPullView.layer.masksToBounds = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить") { [weak self] _, _, completion in
                let alert = UIAlertController(
                    title: nil,
                    message: "Уверены что хотите удалить контакт?",
                    preferredStyle: .actionSheet)
                
                let confirmAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                    guard let self else { return }
                    self.contactService.deleteContact(at: indexPath.row) { contacts in
                        self.contacts = contacts
                        self.contactsTable.deleteRows(at: [indexPath], with: .automatic)
                        completion(false)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                    completion(true)
                }
                
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                
                self?.present(alert, animated: true)
            }
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - SortViewControllerDelegate

extension ContactListViewController: SortViewControllerDelegate {
    func sortViewControllerDidApplySort(_ vc: SortViewController, sort: Sort?) {
        contactService.applySort(sort) { [weak self] contacts in
            guard let self else { return }
            
            self.contacts = contacts
            contactsTable.reloadData()
            
            if sort != nil {
                sortButton.setImage(UIImage(named: "SortActive"), for: .normal)
            } else {
                sortButton.setImage(UIImage(named: "Sort"), for: .normal)
            }
            
            dismiss(animated: true)
        }
    }
}

extension ContactListViewController: FilterViewControllerDelegate {
    func filterViewControllerDidApplyFilters(_ vc: FilterViewController, filters: Set<Filter>) {
        contactService.applyFilters(filters) { [weak self] contacts in
            guard let self else { return }
            
            self.contacts = contacts
            contactsTable.reloadData()
            
            if !filters.isEmpty {
                filterButton.setImage(UIImage(named: "FilterActive"), for: .normal)
            } else {
                filterButton.setImage(UIImage(named: "Filter"), for: .normal)
            }
            
            dismiss(animated: true)
        }
    }
}
