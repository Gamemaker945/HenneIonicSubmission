package io.ionic.starter;

import android.content.Context;

import com.getcapacitor.JSArray;

import java.util.List;

public class ContactsService {

    public JSArray getContactsAsJson(Context context) {
        ContactsClient client = new ContactsClient();

        List<Contact> contactList = client.readContacts(context);

        JSArray result = new JSArray();
        for (int i = 0; i < contactList.size(); i++) {
            result.put(contactList.get(i).toJson());
        }

        return result;
    }
}
