//
//  ContactService.swift
//  YP-contacts
//
//  Created by Andrey Sysoev on 23.02.2023.
//

import Contacts
import UIKit

protocol ContactLoading {
    var appliedSort: Sort? { get }
    
    func requestAccess(completion: @escaping (Bool) -> Void)
    func loadContacts(completion: @escaping ([Contact]) -> Void)
    func deleteContact(at index: Int, completion: ([Contact]) -> Void)
    func applySort(_ sort: Sort?, completion: ([Contact]) -> Void)
}

final class ContactService: ContactLoading {
    static let shared = ContactService()
    private let store = CNContactStore()
    private(set) var appliedSort: Sort?
    private var contacts: [Contact] = []
    
    private init() {}
    
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
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                var cnContacts = [CNContact]()
                try self.store.enumerateContacts(with: request, usingBlock: { contact, _ in
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
                
                self.contacts = contacts
                
                DispatchQueue.main.async {
                    completion(contacts)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func deleteContact(at index: Int, completion: ([Contact]) -> Void) {
        contacts.remove(at: index)
        completion(contacts)
    }
    
    func applySort(_ sort: Sort?, completion: ([Contact]) -> Void) {
        appliedSort = sort
        
        guard let sort else {
            completion(contacts)
            return
        }
        
        let sorted = contacts.sorted { first, second in
            switch sort.value {
            case .givenName:
                switch sort.direction {
                case .ascending:
                    return first.givenName < second.givenName
                case .descending:
                    return first.givenName > second.givenName
                }
            case .familyName:
                switch sort.direction {
                case .ascending:
                    return first.familyName < second.familyName
                case .descending:
                    return first.familyName > second.familyName
                }
            }
        }
        
        completion(sorted)
    }
}
