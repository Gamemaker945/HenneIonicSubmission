package io.ionic.starter;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.provider.ContactsContract;

import java.util.ArrayList;
import java.util.List;

public class ContactsClient {

    public List<Contact> readContacts(Context context){

        List<Contact> result = new ArrayList<>();

        ContentResolver cr = context.getContentResolver();
        Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI,
                null, null, null, null);

        if ((cur != null ? cur.getCount() : 0) > 0) {

            while (cur.moveToNext()) {

                String firstName = "";
                String lastName = "";
                List<String> emails = new ArrayList<String>();
                List<String> phones = new ArrayList<String>();


                String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));

                String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
                String[] parts = name.split(" ");
                firstName = parts[0];
                lastName = parts.length > 1 ? parts[1] : "";

                if (cur.getInt(cur.getColumnIndex( ContactsContract.Contacts.HAS_PHONE_NUMBER)) > 0) {

                    Cursor phoneCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,
                            ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?",
                            new String[]{id}, null);
                    if (phoneCur.getCount() > 0) {
                        while (phoneCur.moveToNext()) {
                            String phone = phoneCur.getString(phoneCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
                            phones.add(phone);
                        }
                    }
                    phoneCur.close();


                    Cursor emailCur = cr.query(
                            ContactsContract.CommonDataKinds.Email.CONTENT_URI,
                            null,
                            ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?",
                            new String[]{id}, null);
                    if (emailCur.getCount() > 0) {
                        while (emailCur.moveToNext()) {

                            String email = emailCur.getString(emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
                            emails.add(email);
                        }
                    }
                    emailCur.close();
                }

                Contact contact = new Contact(firstName, lastName, phones, emails);
                result.add(contact);
            }
        }

        return result;
    }
}
