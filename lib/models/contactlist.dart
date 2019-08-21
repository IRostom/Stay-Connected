import 'package:flutter/foundation.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:contacts_service/contacts_service.dart';

class Contactlist extends ChangeNotifier {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _allContacts = new List<CustomContact>();

  Contactlist() {
    refreshContacts();
  }

  List<CustomContact> _favContact = new List<CustomContact>();

  void addfav(CustomContact customContact) {
    if (customContact.isChecked) {
      _favContact.add(customContact);
      _favContact[_favContact.length - 1].id = _favContact.length - 1;
    }
    else{
      _favContact.remove(customContact);
      for (var i = 0; i < _favContact.length; i++) {
        _favContact[i].id = i;
      }
    }
    notifyListeners();
  }

  refreshContacts() async {
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    /* _uiCustomContacts = _allContacts
        .where((contact) => contact.isChecked == true)
        .toList(); */ //kant fl set state
  }

  List<CustomContact> get allcontacts => _allContacts;
  List<CustomContact> get favcontacts => _favContact;
}
