//
//  ApplyAllCell.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 26.02.2023.
//

import UIKit

protocol ApplyAllCellDelegate: AnyObject {
    func applyAllCellDidChange(_ cell: ApplyAllCell)
}

final class ApplyAllCell: UITableViewCell {
    // MARK: - Layout
    
    private let capsuleView: UIView = CapsuleView()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.text = "Выбрать все"
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
    
    weak var delegate: ApplyAllCellDelegate?
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func toggleButton(to value: Bool) {
        if value {
            checkboxButton.setImage(UIImage(named: "CheckboxActive"), for: .normal)
        } else {
            checkboxButton.setImage(UIImage(named: "Checkbox"), for: .normal)
        }
    }
    
    @objc private func didTapCheckboxButton() {
        delegate?.applyAllCellDidChange(self)
    }
}

private extension ApplyAllCell {
    func setupContent() {
        contentView.backgroundColor = .fullBlack
        contentView.addSubview(capsuleView)
        contentView.addSubview(label)
        contentView.addSubview(checkboxButton)
    }
    
    func setupConstraints() {
        let capsuleViewConstraints = [
            capsuleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            capsuleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            capsuleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            capsuleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ]
        let filterLabelConstraints = [
            label.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -20),
        ]
        let checkboxButtonConstraints = [
            checkboxButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(
            capsuleViewConstraints +
            filterLabelConstraints +
            checkboxButtonConstraints
        )
    }
}
