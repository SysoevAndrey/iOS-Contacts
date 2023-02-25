//
//  SortCell.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 25.02.2023.
//

import UIKit

protocol SortCellDelegate: AnyObject {
    func sortCellDidSelect(_ cell: SortCell, sort: Sort)
}

final class SortCell: UITableViewCell {
    // MARK: - Layout
    
    private let capsuleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.backgroundColor = .black
        return view
    }()
    private let sortLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    private lazy var radioButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Radio"), for: .normal)
        button.addTarget(self, action: #selector(didTapRadioButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "SortCell"
    weak var delegate: SortCellDelegate?
    private var sort: Sort?
    
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
        sort = nil
    }
    
    // MARK: - Methods
    
    func configureCell(with sort: Sort, isApplied: Bool) {
        self.sort = sort
        sortLabel.text = sort.name
        toggleButton(to: isApplied)
    }
    
    func toggleButton(to value: Bool) {
        if value {
            radioButton.setImage(UIImage(named: "RadioActive"), for: .normal)
        } else {
            radioButton.setImage(UIImage(named: "Radio"), for: .normal)
        }
    }
    
    @objc private func didTapRadioButton() {
        guard let sort else { return }
        delegate?.sortCellDidSelect(self, sort: sort)
    }
}

private extension SortCell {
    func setupContent() {
        contentView.backgroundColor = .fullBlack
        contentView.addSubview(capsuleView)
        contentView.addSubview(sortLabel)
        contentView.addSubview(radioButton)
    }
    
    func setupConstraints() {
        let capsuleViewConstraints = [
            capsuleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            capsuleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            capsuleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            capsuleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ]
        let sortLabelConstraints = [
            sortLabel.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 16),
            sortLabel.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 20),
            sortLabel.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -20),
        ]
        let radioButtonConstraints = [
            radioButton.centerYAnchor.constraint(equalTo: sortLabel.centerYAnchor),
            radioButton.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(
            capsuleViewConstraints +
            sortLabelConstraints +
            radioButtonConstraints
        )
    }
}
