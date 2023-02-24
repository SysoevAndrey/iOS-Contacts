//
//  SplashViewController.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 23.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Layout
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    private lazy var getContactsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Хочу увидеть свои контакты", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Properties
    
    private var contactService: ContactLoading = ContactService()
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupContent()
        setupConstraints()
        contactService.requestAccess { [weak self] isGranted in
            if isGranted {
                guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration") }
                window.rootViewController = ContactListViewController()
            } else {
                self?.getContactsButton.isHidden = false
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func goToSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}

private extension SplashViewController {
    func setupContent() {
        view.backgroundColor = .fullBlack
        view.addSubview(logo)
        view.addSubview(getContactsButton)
    }
    
    func setupConstraints() {
        let logoConstraints = [
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ]
        let getContactsButtonConstraints = [
            getContactsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            getContactsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            getContactsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            getContactsButton.heightAnchor.constraint(equalToConstant: 64),
            getContactsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ]
        NSLayoutConstraint.activate(logoConstraints + getContactsButtonConstraints)
    }
}
