//
//  SearchContactsViewModelTests.swift
//  AscendaTests
//
//  Created by LocNguyen on 10/02/2022.
//

import XCTest
import UIKit
@testable import Ascenda

final class SearchContactsViewModelTests: XCTestCase {

    var sut: SearchContactsViewModel!
    var contactRepository: ContactRepositoryMock!
    
    override func setUp() {
        super.setUp()
        contactRepository = .init()
        sut = SearchContactsViewModel(contactRepository: contactRepository)
    }

    override func tearDown() {
        sut = nil
        contactRepository = nil
        super.tearDown()
    }
    
    func testFetchContacts() {
        let expectation = XCTestExpectation()
        expectation.isInverted = true
        let contact1 = Contact(name: "1", address: "")
        let contact2 = Contact(name: "2", address: "")
        contactRepository.mockContacts = [contact1, contact2]
        
        let delegate = MockSearchContactsViewModelDelegate()
        sut.delegate = delegate
        
        sut.fetchContacts(searchText: "abc")
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(contactRepository.searchText, "abc")
        XCTAssertEqual(contactRepository.page, 1)
        XCTAssertEqual(contactRepository.resultsPerPage, 10000)
        XCTAssertEqual(sut.contactAt(index: 0).name, "1")
        XCTAssertEqual(sut.contactAt(index: 1).name, "2")
        XCTAssertEqual(delegate.didFetchedContactsCalled, true)
        XCTAssertEqual(delegate.contacts.count, 2)
    }
    
    func testFetchEmptyContacts() {
        let expectation = XCTestExpectation()
        expectation.isInverted = true
        contactRepository.mockContacts = []
        
        let delegate = MockSearchContactsViewModelDelegate()
        sut.delegate = delegate
        
        sut.fetchContacts(searchText: "abc")
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(contactRepository.searchText, "abc")
        XCTAssertEqual(contactRepository.page, 1)
        XCTAssertEqual(contactRepository.resultsPerPage, 10000)
        XCTAssertEqual(delegate.didFetchedContactsCalled, true)
        XCTAssertEqual(delegate.contacts.count, 0)
    }
    
    func testFetchContactsWithEmptySearchText() {
        let expectation = XCTestExpectation()
        expectation.isInverted = true
        let contact = Contact(name: "2", address: "")
        contactRepository.mockContacts = [contact]
        
        let delegate = MockSearchContactsViewModelDelegate()
        sut.delegate = delegate
        
        sut.fetchContacts(searchText: "")
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(contactRepository.searchText, nil)
        XCTAssertEqual(contactRepository.page, 1)
        XCTAssertEqual(contactRepository.resultsPerPage, 10000)
        XCTAssertEqual(sut.contactAt(index: 0).name, "2")
        XCTAssertEqual(delegate.didFetchedContactsCalled, true)
        XCTAssertEqual(delegate.contacts.count, 1)
    }

}

final class ContactRepositoryMock: ContactRepositoryProtocol {
    
    var mockContacts : [Contact] = []
    var searchText: String?
    var page = -1
    var resultsPerPage = -1
    
    func fetchContacts(searchText: String?, page: Int, resultsPerPage: Int, completion: @escaping ([Contact]) -> Void) {
        self.searchText = searchText
        self.page = page
        self.resultsPerPage = resultsPerPage
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                completion([])
                return
            }
            completion(self.mockContacts)
        }
        
    }
}

final class MockSearchContactsViewModelDelegate: SearchContactsViewModelDelegate {
    var didFetchedContactsCalled = false
    var contacts: [Contact] = []
    
    func didFetchedContacts(_ contacts: [Contact]) {
        didFetchedContactsCalled = true
        self.contacts = contacts
    }
    
    func didLoadMoreContacts(_ contacts: [Contact]) {
    }
    
}
