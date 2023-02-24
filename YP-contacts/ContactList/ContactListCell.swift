//
//  ContactListCell.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 24.02.2023.
//

import UIKit

final class ContactListCell: UITableViewCell {
    // MARK: - Layout
    
    private let capsuleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.backgroundColor = .black
        return view
    }()
    private let contactImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        return imageView
    }()
    private let contactName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        return label
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
        contactName.text = "\(contact.givenName) \(contact.familyName)"
    }
}

private extension ContactListCell {
    func setupContent() {
        contentView.backgroundColor = .fullBlack
        contentView.addSubview(capsuleView)
        contentView.addSubview(contactImage)
        contentView.addSubview(contactName)
    }
    
    func setupConstraints() {
        let capsuleViewConstraints = [
            capsuleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            capsuleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            capsuleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            capsuleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ]
        let contactImageConstraints = [
            contactImage.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 12),
            contactImage.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 12),
            contactImage.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -12),
            contactImage.widthAnchor.constraint(equalToConstant: 96),
            contactImage.heightAnchor.constraint(equalTo: contactImage.widthAnchor)
        ]
        let contactNameConstraints = [
            contactName.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 12),
            contactName.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 12),
            contactName.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(
            capsuleViewConstraints +
            contactImageConstraints +
            contactNameConstraints
        )
    }
}
