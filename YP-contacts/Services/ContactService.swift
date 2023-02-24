//
//  ContactService.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 23.02.2023.
//

import Contacts
import UIKit

protocol ContactLoading {
    func requestAccess(completion: @escaping (Bool) -> Void)
    func loadContacts(completion: @escaping ([Contact]) -> Void)
}

struct ContactService: ContactLoading {
    private let store = CNContactStore()
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        store.requestAccess(for: .contacts) { isGranted, _ in
            DispatchQueue.main.async {
                completion(isGranted)
            }
        }
    }
    
    func loadContacts(completion: @escaping ([Contact]) -> Void) {
        let request = CNContactFetchRequest(keysToFetch: [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactThumbnailImageDataKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactSocialProfilesKey
        ] as [CNKeyDescriptor])
        
        DispatchQueue.global().async {
            do {
                var cnContacts = [CNContact]()
                try store.enumerateContacts(with: request, usingBlock: { contact, _ in
                    cnContacts.append(contact)
                })
                let contacts = cnContacts.map { cnContact in
                    var image: UIImage
                    if
                        let imageData = cnContact.thumbnailImageData,
                        let imageFromData = UIImage(data: imageData)
                    {
                        image = imageFromData
                    } else {
                        image = UIImage(named: "AvatarPlaceholder") ?? UIImage()
                    }
                    
                    let phone: String? = cnContact.phoneNumbers.first?.value.stringValue
                    
                    let email: String? = cnContact.emailAddresses.first?.value as String?
                    
                    var socials: Set<Social> = []
                    cnContact.socialProfiles.forEach { profile in
                        if let value = Social(rawValue: profile.value.service) {
                            socials.insert(value)
                        }
                    }
                    
                    return Contact(
                        givenName: cnContact.givenName,
                        familyName: cnContact.familyName,
                        image: image,
                        phone: phone,
                        email: email,
                        socials: socials
                    )
                }
                
                completion(contacts)
            } catch {
                completion([])
            }
        }
    }
}
