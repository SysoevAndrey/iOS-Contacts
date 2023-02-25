//
//  SortViewController.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 25.02.2023.
//

import UIKit

class SortViewController: UIViewController {
    // MARK: - Layout
    
    private let sortsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .fullBlack
        table.separatorStyle = .none
        table.register(SortCell.self, forCellReuseIdentifier: SortCell.reuseIdentifier)
        return table
    }()
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 11
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var resetButton: UIButton = {
        let button = Button(color: .clear, title: "Сбросить")
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }()
    private let applyButton: UIButton = {
        let button = Button(color: .blue, title: "Применить")
        return button
    }()
    
    // MARK: - Properties
    
    private let contactService: ContactLoading = ContactService()
    private let sorts: [Sort] = [
        Sort(name: "По имени (А-Я / A-Z)", direction: .ascending),
        Sort(name: "По имени (Я-А / Z-A)", direction: .descending),
        Sort(name: "По фамилии (А-Я / A-Z)", direction: .ascending),
        Sort(name: "По фамилии (Я-А / Z-A)", direction: .descending),
    ]
    private var appliedSort: Sort?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortsTable.dataSource = self
        
        appliedSort = contactService.appliedSort
        
        setupContent()
        setupConstraints()
    }
    
    // MARK: - Methods
    
    @objc private func didTapResetButton() {
        sortsTable.visibleCells.forEach { cell in
            guard let sortCell = cell as? SortCell else { return }
            sortCell.toggleButton(to: false)
        }
        
        appliedSort = nil
    }
}

private extension SortViewController {
    func setupContent() {
        view.backgroundColor = .fullBlack
        view.addSubview(sortsTable)
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(resetButton)
        buttonsStack.addArrangedSubview(applyButton)
    }
    
    func setupConstraints() {
        let sortsTableConstraints = [
            sortsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            sortsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            sortsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            sortsTable.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor)
        ]
        let buttonsStackConstraints = [
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonsStack.heightAnchor.constraint(equalToConstant: 64)
        ]
        NSLayoutConstraint.activate(sortsTableConstraints + buttonsStackConstraints)
    }
}

// MARK: - UITableViewDataSource

extension SortViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sorts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sortsTable.dequeueReusableCell(withIdentifier: SortCell.reuseIdentifier)
        
        guard let sortCell = cell as? SortCell else {
            return UITableViewCell()
        }
        
        sortCell.configureCell(with: sorts[indexPath.row], isApplied: sorts[indexPath.row].name == appliedSort?.name)
        sortCell.delegate = self
        
        return sortCell
    }
}

// MARK: - SortCellDelegate

extension SortViewController: SortCellDelegate {
    func sortCellDidSelect(_ cell: SortCell, sort: Sort) {
        sortsTable.visibleCells.forEach { cell in
            guard let sortCell = cell as? SortCell else { return }
            sortCell.toggleButton(to: false)
        }

        appliedSort = sort
        
        cell.toggleButton(to: true)
    }
}
