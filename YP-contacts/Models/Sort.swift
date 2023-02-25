//
//  Sort.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 25.02.2023.
//

import Foundation

struct Sort {
    let name: String
    let direction: Direction
    
    enum Direction {
        case ascending, descending
    }
}
