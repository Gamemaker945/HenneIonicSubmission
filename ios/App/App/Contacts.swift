import Foundation
import Capacitor

@objc(Contacts)
public class Contacts : CAPPlugin {
    @objc func getAll(_ call: CAPPluginCall) {
        let contactsService = ContactsService(client: ContactsClient())
        contactsService.getAllContacts(encoded: true) { (contacts, error) in
            if let error = error {
                call.error(error.localizedDescription)
            } else {
                call.success([
                    "contacts": contacts
                ])
            }
        }
    }
    
    // Other potential calls
    // getByKey (i.e. firstName, lastName, phone, etc.)
    // hasContacts()
    // count()
    // getKeyValueFor (i.e. get phone number for firstname, lastname)
    // addContact
    // editContact
    // deleteContact
}
