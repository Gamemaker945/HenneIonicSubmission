package io.ionic.starter;

import android.Manifest;
import android.content.pm.PackageManager;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

import java.util.Arrays;

@NativePlugin(
    requestCodes = { ContactsPlugin.GET_ALL_REQUEST }
)
public class ContactsPlugin extends Plugin {
  static final int GET_ALL_REQUEST = 30033;

  @PluginMethod()
  public void getAll(PluginCall call) {
    if (!hasPermission(Manifest.permission.READ_CONTACTS) || !hasPermission(Manifest.permission.WRITE_CONTACTS)) {
      saveCall(call);
      pluginRequestPermissions(new String[] { Manifest.permission.READ_CONTACTS, Manifest.permission.WRITE_CONTACTS }, GET_ALL_REQUEST);
      return;
    }

    JSObject result = new JSObject();
    ContactsService service = new ContactsService();
    JSArray mockedContacts = service.getContactsAsJson(getContext());
    result.put("contacts", mockedContacts);
    call.success(result);
  }

  @Override
  protected void handleRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    super.handleRequestPermissionsResult(requestCode, permissions, grantResults);

    PluginCall savedCall = getSavedCall();
    if (savedCall == null) {
      return;
    }

    for(int result : grantResults) {
      if (result == PackageManager.PERMISSION_DENIED) {
        savedCall.error("User denied permission");
        return;
      }
    }

    if (requestCode == GET_ALL_REQUEST) {
      this.getAll(savedCall);
    }
  }
}
