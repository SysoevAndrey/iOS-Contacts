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
    private let contactNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let contactPhoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private let contactSocialsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    override func prepareForReuse() {
        contactSocialsStack.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    // MARK: - Methods
    
    func configureCell(with contact: Contact) {
        contactImage.image = contact.image
        contactNameLabel.text = "\(contact.givenName) \(contact.familyName)"
        contactPhoneLabel.text = contact.phone
        
        let sortedSocials = Array(contact.socials).sorted()
        
        sortedSocials.forEach { social in
            let image = UIImage(named: "\(social.rawValue)\(contactSocialsStack.arrangedSubviews.count == 0 ? "" : "Hidden")")
            contactSocialsStack.addArrangedSubview(UIImageView(image: image))
        }
        
        if contact.phone != nil {
            contactSocialsStack.addArrangedSubview(UIImageView(image: UIImage(named: "Phone\(contactSocialsStack.arrangedSubviews.count == 0 ? "" : "Hidden")")))
        }
        
        if contact.email != nil {
            contactSocialsStack.addArrangedSubview(UIImageView(image: UIImage(named: "Email\(contactSocialsStack.arrangedSubviews.count == 0 ? "" : "Hidden")")))
        }
    }
}

private extension ContactListCell {
    func setupContent() {
        contentView.backgroundColor = .fullBlack
        contentView.addSubview(capsuleView)
        contentView.addSubview(contactImage)
        contentView.addSubview(contactNameLabel)
        contentView.addSubview(contactPhoneLabel)
        contentView.addSubview(contactSocialsStack)
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
            contactNameLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 12),
            contactNameLabel.topAnchor.constraint(equalTo: contactImage.topAnchor),
            contactNameLabel.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -12)
        ]
        let contactPhoneLabelConstraints = [
            contactPhoneLabel.leadingAnchor.constraint(equalTo: contactNameLabel.leadingAnchor),
            contactPhoneLabel.topAnchor.constraint(equalTo: contactNameLabel.bottomAnchor, constant: 4),
            contactPhoneLabel.trailingAnchor.constraint(equalTo: contactNameLabel.trailingAnchor)
        ]
        let contactSocialsStackConstraints = [
            contactSocialsStack.leadingAnchor.constraint(equalTo: contactNameLabel.leadingAnchor),
            contactSocialsStack.trailingAnchor.constraint(lessThanOrEqualTo: contactNameLabel.trailingAnchor),
            contactSocialsStack.bottomAnchor.constraint(equalTo: contactImage.bottomAnchor),
            contactSocialsStack.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        NSLayoutConstraint.activate(
            capsuleViewConstraints +
            contactImageConstraints +
            contactNameConstraints +
            contactPhoneLabelConstraints +
            contactSocialsStackConstraints
        )
    }
}
