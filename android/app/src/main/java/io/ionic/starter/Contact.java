package io.ionic.starter;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class Contact {

    private String firstName;
    private String lastName;
    private List<String> emailAddresses;
    private List<String> phoneNumbers;

    public Contact(String firstName, String lastName, List<String> emailAddresses, List<String> phoneNumbers) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.emailAddresses = new ArrayList(emailAddresses);
        this.phoneNumbers = new ArrayList(phoneNumbers);
    }

    public JSONObject toJson() {
        JSObject json = new JSObject();
        json.put("firstName", firstName);
        json.put("lastName", lastName);
        json.put("phoneNumbers", new JSArray(phoneNumbers));
        json.put("emailAddresses", new JSArray(emailAddresses));
        return json;
    }
}
