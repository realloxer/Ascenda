//
//  SearchContactsViewModel.swift
//  Ascenda
//
//  Created by LocNguyen on 10/02/2022.
//

import Foundation

protocol SearchContactsViewModelDelegate: AnyObject {
    func didFetchedContacts(_ contacts: [Contact])
    // load more will be implemented later
    func didLoadMoreContacts(_ contacts: [Contact])
}

final class SearchContactsViewModel {
    private let contactRepository: ContactRepositoryProtocol
    private var currentContacts: [Contact] = []
    private(set) var currentSearchText: String?
    private var currentPage = 0
    
    // load more will be implemented later so we will fetch 10000 contacts at once
    private let resultsPerPage = 10000
    var delegate: SearchContactsViewModelDelegate?
    
    var count: Int {
        return currentContacts.count
    }

    init(contactRepository: ContactRepositoryProtocol) {
        self.contactRepository = contactRepository
    }
    
    private func performFetchingContacts() {
        contactRepository.fetchContacts(searchText: currentSearchText, page: 1, resultsPerPage: resultsPerPage) { [weak self] contacts in
            guard let self = self else { return }
            if !contacts.isEmpty {
                self.currentPage += 1
            }
            self.currentContacts = contacts
            self.delegate?.didFetchedContacts(self.currentContacts)
        }
    }
    
    func fetchContacts(searchText: String? = nil) {
        currentPage = 0
        if searchText == "" {
            currentSearchText = nil
        } else {
            currentSearchText = searchText
        }

        performFetchingContacts()
    }
    
    func onViewDidLoad() {
        performFetchingContacts()
    }
    
    func contactAt(index: Int) -> Contact {
        return currentContacts[index]
    }
}
