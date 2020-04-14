//
//  AppTests.swift
//  AppTests
//
//  Created by Christian Henne on 4/14/20.
//

import XCTest
@testable import App

class AppContactServiceTests: XCTestCase {

    var clientMock: ContactsClientMock!
    var subject: ContactsService!
    
    override func setUp() {
        clientMock = ContactsClientMock()
        subject = ContactsService(client: clientMock)
    }

    func testContactService_GoodFetch() {
        let fetchCompletedExpectation = expectation(description: "Fetch Completed")
        var results:[Any] = []
        
        subject.getAllContacts(encoded: true) { (contacts, error) in
            if error != nil {
                XCTFail("Received unexpected error")
            } else {
                results = contacts
                fetchCompletedExpectation.fulfill()
            }
        }
        
        wait(for: [fetchCompletedExpectation], timeout: 1)
        XCTAssertEqual(results.count, 2)
    }
    
    func testContactService_EmptyFetch() {
        let fetchCompletedExpectation = expectation(description: "Fetch Completed")
        var results:[Any] = []
        clientMock.hasNoContacts = true
        
        subject.getAllContacts(encoded: true) { (contacts, error) in
            if error != nil {
                XCTFail("Received unexpected error")
            } else {
                results = contacts
                fetchCompletedExpectation.fulfill()
            }
        }
        
        wait(for: [fetchCompletedExpectation], timeout: 1)
        XCTAssertEqual(results.count, 0)
    }
    
    func testContactService_FetchError() {
        let fetchCompletedExpectation = expectation(description: "Fetch Completed")
        let results:[Any] = []
        clientMock.hasError = true
        
        subject.getAllContacts(encoded: true) { (contacts, error) in
            if error != nil {
                fetchCompletedExpectation.fulfill()
            } else {
                XCTFail("Received data when expecting error")
            }
        }
        
        wait(for: [fetchCompletedExpectation], timeout: 1)
        XCTAssertEqual(results.count, 0)
    }

}

class ContactsClientMock: ContactsClientType {
    var hasError: Bool = false
    var hasNoContacts: Bool = false
    
    func getAllContacts(onComplete: ((_ contacts: [Contact], _ error: Error?) -> Void)) {
        if hasError {
            onComplete([], ContactsClientError.fetchError)
        } else {
            if hasNoContacts {
                onComplete([], nil)
            } else {
                let contacts = getMockContacts()
                onComplete(contacts, nil)
            }
        }
    }
    
    private func getMockContacts() -> [Contact] {
        let contact1 = Contact(firstName: "John", lastName: "Smith", phoneNumbers: ["111-222-3333"], emailAddresses: ["john.smith@gmail.com"])
        let contact2 = Contact(firstName: "Mike", lastName: "Jones", phoneNumbers: ["111-222-3333", "222-333-4444"], emailAddresses: ["mike.jones@gmail.com", "mike.jones@ionic.com"])
        return [contact1, contact2]
    }
}
