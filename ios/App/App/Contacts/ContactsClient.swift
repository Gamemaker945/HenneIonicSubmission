//
//  ContactsClient.swift
//  App
//
//  Created by Christian Henne on 4/14/20.
//

import Foundation
import ContactsUI

public enum ContactsClientError: Error {
    case fetchError

    public var localizedDescription: String {
      switch self {
      case .fetchError:
        return NSLocalizedString("There was an issue fetching your contacts. Please try again later.", comment: "Fetch Error")
      }
    }
}

public protocol ContactsClientType {
    
    func getAllContacts(onComplete: ((_ contacts: [Contact], _ error: Error?) -> Void))
}

class ContactsClient: ContactsClientType {
    
    func getAllContacts(onComplete: ((_ contacts: [Contact], _ error: Error?) -> Void)) {
        
        let contactStore = CNContactStore()
        
        var contactContainers: [CNContainer] = []
        do {
            contactContainers = try contactStore.containers(matching: nil)
        } catch {
            onComplete([], ContactsClientError.fetchError)
            return
        }
        
        var contacts: [CNContact] = []
        for container in contactContainers {
            do {
                let contact = try contactStore.unifiedContacts(matching: CNContact.predicateForContactsInContainer(withIdentifier: container.identifier),
                                                               keysToFetch: [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as! [CNKeyDescriptor])
                contacts.append(contentsOf: contact)
            } catch {
                onComplete([], ContactsClientError.fetchError)
                return
            }
        }
        
        let results: [Contact] = contacts.map { Contact(contact: $0) }
        onComplete(results, nil)
    }
}
