//
//  FilterCell.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 26.02.2023.
//

import UIKit

protocol FilterCellDelegate: AnyObject {
    func filterCellDidSelect(_ cell: FilterCell, filter: Filter)
}

final class FilterCell: UITableViewCell {
    // MARK: - Layout
    
    private let capsuleView: UIView = CapsuleView()
    private let filterIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Checkbox"), for: .normal)
        button.addTarget(self, action: #selector(didTapCheckboxButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "FilterCell"
    weak var delegate: FilterCellDelegate?
    private var filter: Filter?
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        filter = nil
    }
    
    // MARK: - Methods
    
    func configureCell(with filter: Filter, isApplied: Bool) {
        self.filter = filter
        filterIcon.image = filter.icon
        filterLabel.text = filter.label
        toggleButton(to: isApplied)
    }
    
    func toggleButton(to value: Bool) {
        if value {
            checkboxButton.setImage(UIImage(named: "CheckboxActive"), for: .normal)
        } else {
            checkboxButton.setImage(UIImage(named: "Checkbox"), for: .normal)
        }
    }
    
    @objc private func didTapCheckboxButton() {
        guard let filter else { return }
        delegate?.filterCellDidSelect(self, filter: filter)
    }
}

private extension FilterCell {
    func setupContent() {
        contentView.backgroundColor = .fullBlack
        contentView.addSubview(capsuleView)
        contentView.addSubview(filterIcon)
        contentView.addSubview(filterLabel)
        contentView.addSubview(checkboxButton)
    }
    
    func setupConstraints() {
        let capsuleViewConstraints = [
            capsuleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            capsuleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            capsuleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            capsuleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ]
        let filterIconConstraints = [
            filterIcon.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 16),
            filterIcon.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor)
        ]
        let filterLabelConstraints = [
            filterLabel.leadingAnchor.constraint(equalTo: filterIcon.trailingAnchor, constant: 8),
            filterLabel.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 20),
            filterLabel.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -20),
        ]
        let checkboxButtonConstraints = [
            checkboxButton.centerYAnchor.constraint(equalTo: filterIcon.centerYAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(
            capsuleViewConstraints +
            filterIconConstraints +
            filterLabelConstraints +
            checkboxButtonConstraints
        )
    }
}
