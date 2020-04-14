//
//  Contact.swift
//  App
//
//  Created by Christian Henne on 4/14/20.
//

import Foundation
import ContactsUI

public struct Contact {
    
    struct Constants {
        struct Keys {
            static let firstNameKey = "firstName"
            static let lastNameKey = "lastName"
            static let phoneKey = "phoneNumbers"
            static let emailKey = "emailAddresses"
        }
    }
    
    let firstName: String
    let lastName: String
    let phoneNumbers: [String]
    let emailAddresses: [String]
    
    init(firstName: String, lastName: String, phoneNumbers: [String], emailAddresses: [String]) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumbers = phoneNumbers
        self.emailAddresses = emailAddresses
    }

    init(contact: CNContact) {
        firstName = contact.givenName
        lastName = contact.familyName
        
        var phones:[String] = []
        for number in contact.phoneNumbers {
            phones.append(number.value.stringValue)
        }
        phoneNumbers = phones
        
        var emails:[String] = []
        for email in contact.emailAddresses {
            emails.append(email.value as String)
        }
        emailAddresses = emails
    }
    
    public func toJson() -> [String: Any] {
        return [
            Constants.Keys.firstNameKey: firstName,
            Constants.Keys.lastNameKey: lastName,
            Constants.Keys.phoneKey: phoneNumbers,
            Constants.Keys.emailKey: emailAddresses
        ]
    }
}
