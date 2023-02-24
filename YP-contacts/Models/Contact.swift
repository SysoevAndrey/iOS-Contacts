//
//  Contact.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 23.02.2023.
//

import UIKit

struct Contact {
    let givenName: String
    let familyName: String
    let image: UIImage
    let phone: String?
    let email: String?
    let socials: Set<Social>
}

enum Social: String {
    case telegram = "Telegram"
    case whatsApp = "‎WhatsApp"
    case viber = "Viber,"
    case signal = "Signal,"
    case threema = "Threema"
}
