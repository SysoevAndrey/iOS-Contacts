//
//  Button.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 25.02.2023.
//

import UIKit

final class Button: UIButton {
    convenience init(color: UIColor, title: String) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        self.backgroundColor = color
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.layer.cornerRadius = 24
    }
}
