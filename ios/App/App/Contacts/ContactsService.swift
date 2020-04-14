//
//  ContactsService.swift
//  App
//
//  Created by Christian Henne on 4/14/20.
//

import Foundation
import ContactsUI


class ContactsService {
    
    let contactClient: ContactsClientType
    
    init(client: ContactsClientType) {
        self.contactClient = client
    }
    
    public func getAllContacts(encoded: Bool, onComplete: ((_ contacts: [Any], _ error: Error?) -> Void)) {
        contactClient.getAllContacts { [weak self] (contacts, error) in
            guard self != nil else { return }
            
            if let error = error {
                onComplete([], error)
                return
            } else {
                if !encoded {
                    onComplete(contacts, nil)
                } else {
                    var result: [Any] = []
                    for contact in contacts {
                        result.append(contact.toJson())
                    }
                    onComplete(result, nil)
                }
            }
        }
    }
}
