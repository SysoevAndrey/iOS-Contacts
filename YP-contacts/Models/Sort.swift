//
//  Sort.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 25.02.2023.
//

import Foundation

struct Sort: Equatable {
    let value: Value
    let direction: Direction
    
    var label: String {
        var result = ""
        
        switch value {
        case .givenName:
            result += "По имени"
        case .familyName:
            result += "По фамилии"
        }
        
        switch direction {
        case .ascending:
            result += " (А-Я / A-Z)"
        case .descending:
            result += " (Я-А / Z-A)"
        }
        
        return result
    }
    
    enum Direction {
        case ascending, descending
    }
    
    enum Value: String, Equatable {
        case givenName, familyName
    }
}
