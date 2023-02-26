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
    var appliedFilters: Set<Filter> { get }
    
    func requestAccess(completion: @escaping (Bool) -> Void)
    func loadContacts(completion: @escaping ([Contact]) -> Void)
    func deleteContact(at index: Int, completion: ([Contact]) -> Void)
    func applySort(_ sort: Sort?, completion: ([Contact]) -> Void)
    func applyFilters(_ filters: Set<Filter>, completion: ([Contact]) -> Void)
}

final class ContactService: ContactLoading {
    static let shared = ContactService()
    private let store = CNContactStore()
    private(set) var appliedSort: Sort?
    private(set) var appliedFilters: Set<Filter> = []
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
                    
                    var socials: Set<Social> = []
                    cnContact.socialProfiles.forEach { profile in
                        if let value = Social(rawValue: profile.value.service) {
                            socials.insert(value)
                        }
                    }
                    
                    let phone: String? = cnContact.phoneNumbers.first?.value.stringValue
                    
                    if phone != nil {
                        socials.insert(.phone)
                    }
                    
                    if let _ = cnContact.emailAddresses.first?.value {
                        socials.insert(.email)
                    }
                    
                    return Contact(
                        givenName: cnContact.givenName,
                        familyName: cnContact.familyName,
                        image: image,
                        phone: phone,
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
        var sortedAndFilteredContacts = applySortAndFilters(to: contacts)
        let contactToDelete = sortedAndFilteredContacts[index]
        
        guard let indexInContacts = contacts.firstIndex(of: contactToDelete) else { return }
        
        let indexToDelete = contacts.distance(from: contacts.startIndex, to: indexInContacts )

        sortedAndFilteredContacts.remove(at: index)
        contacts.remove(at: indexToDelete)
        
        completion(sortedAndFilteredContacts)
    }
    
    func applySort(_ sort: Sort?, completion: ([Contact]) -> Void) {
        appliedSort = sort
        
        let sorted = applySortAndFilters(to: contacts)
        
        completion(sorted)
    }
    
    func applyFilters(_ filters: Set<Filter>, completion: ([Contact]) -> Void) {
        self.appliedFilters = filters
        
        let filtered = applySortAndFilters(to: contacts)
        
        completion(filtered)
    }
    
    private func applySortAndFilters(to contacts: [Contact]) -> [Contact] {
        sortContacts(filterContacts(contacts, by: appliedFilters), by: appliedSort)
    }
    
    private func sortContacts(_ contacts: [Contact], by sort: Sort?) -> [Contact] {
        guard let sort else {
            return contacts
        }
        
        return contacts.sorted { first, second in
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
    }
    
    private func filterContacts(_ contacts: [Contact], by filters: Set<Filter>) -> [Contact] {
        if filters.isEmpty {
            return contacts
        }
        
        return contacts.filter { contact in
            filters.allSatisfy { filter in
                contact.socials.contains(filter.value)
            }
        }
    }
}
