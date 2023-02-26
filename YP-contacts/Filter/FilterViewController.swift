//
//  FilterViewController.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 26.02.2023.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func filterViewControllerDidApplyFilters(_ vc: FilterViewController, filters: Set<Filter>)
}

final class FilterViewController: UIViewController {
    // MARK: - Layout
    
    private let filterTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .fullBlack
        table.separatorStyle = .none
        table.alwaysBounceVertical = false
        table.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
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
    private lazy var applyButton: UIButton = {
        let button = Button(color: .blue, title: "Применить")
        button.addTarget(self, action: #selector(didTapApplyButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: FilterViewControllerDelegate?
    private let contactService: ContactLoading = ContactService.shared
    private let filters: [Filter] = [
        Filter(value: .telegram, label: "Telegram", icon: UIImage(named: "TelegramFilter")!),
        Filter(value: .whatsApp, label: "WhatsApp", icon: UIImage(named: "WhatsAppFilter")!),
        Filter(value: .viber, label: "Viber", icon: UIImage(named: "ViberFilter")!),
        Filter(value: .signal, label: "Signal", icon: UIImage(named: "SignalFilter")!),
        Filter(value: .threema, label: "Threema", icon: UIImage(named: "ThreemaFilter")!),
        Filter(value: .phone, label: "Номер телефона", icon: UIImage(named: "PhoneFilter")!),
        Filter(value: .email, label: "E-mail", icon: UIImage(named: "EmailFilter")!)
    ]
    private var initialFilters: Set<Filter> = []
    private var appliedFilters: Set<Filter> = [] {
        willSet {
            UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                guard let self else { return }
                if newValue == self.initialFilters {
                    self.applyButton.backgroundColor = .gray
                    self.applyButton.isEnabled = false
                } else {
                    self.applyButton.backgroundColor = .blue
                    self.applyButton.isEnabled = true
                }
            }
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTable.dataSource = self
        
        initialFilters = contactService.appliedFilters
        appliedFilters = contactService.appliedFilters
        
        setupContent()
        setupConstraints()
    }
    
    // MARK: - Methods
    
    @objc private func didTapResetButton() {
        filterTable.visibleCells.forEach { cell in
            guard let filterCell = cell as? FilterCell else { return }
            filterCell.toggleButton(to: false)
        }
        
        guard let applyAllCell = filterTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ApplyAllCell else { return }
        applyAllCell.toggleButton(to: false)

        appliedFilters = []
    }
    
    @objc private func didTapApplyButton() {
        delegate?.filterViewControllerDidApplyFilters(self, filters: appliedFilters)
    }
}

private extension FilterViewController {
    func setupContent() {
        view.backgroundColor = .fullBlack
        view.addSubview(filterTable)
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(resetButton)
        buttonsStack.addArrangedSubview(applyButton)
    }
    
    func setupConstraints() {
        let filterTableConstraints = [
            filterTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            filterTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filterTable.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor)
        ]
        let buttonsStackConstraints = [
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonsStack.heightAnchor.constraint(equalToConstant: 64)
        ]
        NSLayoutConstraint.activate(filterTableConstraints + buttonsStackConstraints)
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let applyAllCell = ApplyAllCell()
            applyAllCell.delegate = self
            applyAllCell.toggleButton(to: appliedFilters.count == filters.count)
            return applyAllCell
        }
        
        let cell = filterTable.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath)
        
        guard let filterCell = cell as? FilterCell else {
            return UITableViewCell()
        }
        
        let filter = filters[indexPath.row - 1]
        filterCell.configureCell(with: filter, isApplied: appliedFilters.contains(filter))
        filterCell.delegate = self
        
        return filterCell
    }
}

// MARK: - FilterCellDelegate

extension FilterViewController: FilterCellDelegate {
    func filterCellDidSelect(_ cell: FilterCell, filter: Filter) {
        if appliedFilters.contains(filter) {
            appliedFilters.remove(filter)
            cell.toggleButton(to: false)
        } else {
            appliedFilters.insert(filter)
            cell.toggleButton(to: true)
        }
        
        guard let applyAllCell = filterTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ApplyAllCell else { return }
        
        if appliedFilters.count == filters.count {
            applyAllCell.toggleButton(to: true)
        } else {
            applyAllCell.toggleButton(to: false)
        }
    }
}

// MARK: - ApplyAllCellDelegate

extension FilterViewController: ApplyAllCellDelegate {
    func applyAllCellDidChange(_ cell: ApplyAllCell) {
        if appliedFilters.count == filters.count {
            appliedFilters = []
        } else {
            appliedFilters = Set(filters)
        }
        filterTable.reloadData()
    }
}
