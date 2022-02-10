//
//  ContactRepository.swift
//  Ascenda
//
//  Created by LocNguyen on 10/02/2022.
//

import Foundation

protocol ContactRepositoryProtocol {
    func fetchContacts(searchText: String?, page: Int, resultsPerPage: Int, completion: @escaping ([Contact]) -> Void)
}

final class ContactRepository: ContactRepositoryProtocol {
    
    // Assume that this property is contacts database, we do not use this array if we have a database
    var allContacts : [Contact] = []
    
    init() {
        generateDummyContacts()
    }
    
    func fetchContacts(searchText: String?, page: Int, resultsPerPage: Int, completion: @escaping ([Contact]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var contacts: [Contact]!
            if (searchText == nil) {
                let firsIndex = (page - 1) * resultsPerPage
                let lastIndex = (page * resultsPerPage) - 1
                contacts = Array(self.allContacts[firsIndex...lastIndex])
            } else {
                let filteredContacts = self.allContacts.filter { contact in
                    return contact.name.lowercased().contains(searchText!.lowercased())
                }
                if filteredContacts.isEmpty {
                    completion([])
                    return
                }
                let firsIndex = (page - 1) * resultsPerPage
                var lastIndex = (page * resultsPerPage) - 1
                if lastIndex > filteredContacts.count {
                    lastIndex = filteredContacts.count - 1
                }
                contacts = Array(filteredContacts[firsIndex...lastIndex])
            }
            completion(contacts)
        }
    }
    
    
}

extension ContactRepository {
    private func generateDummyContacts() {
        for i in 0..<10000 {
            let randomName = randomString(length: Int.random(in: 3..<6)) + " " + randomString(length: Int.random(in: 4...7))
            let contact = Contact(name: randomName, address: "Singapore")
            allContacts.append(contact)
        }
    }
    
    private func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
