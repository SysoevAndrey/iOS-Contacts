//
//  Contact.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 23.02.2023.
//

import UIKit

struct Contact: Equatable {
    let givenName: String
    let familyName: String
    let image: UIImage
    let phone: String?
    let socials: Set<Social>
}

enum Social: String, Comparable {
    case telegram = "Telegram"
    case whatsApp = "WhatsApp"
    case viber = "Viber"
    case signal = "Signal"
    case threema = "Threema"
    case phone = "Phone"
    case email = "Email"
    
    static func < (lhs: Social, rhs: Social) -> Bool {
        let order: [Social: Int] = [
            .telegram: 0,
            .whatsApp: 1,
            .viber: 2,
            .signal: 3,
            .threema: 4,
            .phone: 5,
            .email: 6
        ]
        
        return order[lhs] ?? -1 < order[rhs] ?? -1
    }
}
