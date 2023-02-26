//
//  CapsuleView.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 26.02.2023.
//

import UIKit

final class CapsuleView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    convenience init(color: UIColor = .black) {
        self.init(frame: .zero)
        setupView(color: color)
    }
    
    private func setupView(color: UIColor = .black) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 24
        self.backgroundColor = color
    }
}
