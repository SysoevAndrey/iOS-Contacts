//
//  ContactListCell.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 24.02.2023.
//

import UIKit

final class ContactListCell: UITableViewCell {
    // MARK: - Layout
    
    private let contactImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ContactListCell"
    
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
    
    func configureCell(with contact: Contact) {
        contactImage.image = contact.image
    }
}

private extension ContactListCell {
    func setupContent() {
        self.backgroundColor = .fullBlack
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 24
        contentView.addSubview(contactImage)
    }
    
    func setupConstraints() {
        let contactImageConstraints = [
            contactImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contactImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contactImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contactImage.widthAnchor.constraint(equalToConstant: 96),
            contactImage.heightAnchor.constraint(equalTo: contactImage.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(contactImageConstraints)
    }
}
