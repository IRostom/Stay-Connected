import 'package:simple_permissions/simple_permissions.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:contacts_service/contacts_service.dart';
//import 'package:stay_connected/models/contactlist.dart';
import 'package:stay_connected/models/arguments.dart';
//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// TO DO: Add refresh state

class Addcontact extends StatefulWidget {
  @override
  _AddcontactState createState() => new _AddcontactState();
}

class _AddcontactState extends State<Addcontact> {
  bool _isLoading = false;
  List<CustomContact> _allContacts = new List<CustomContact>();
  List<Contact> _contacts = new List<Contact>();

  @override
  void initState() {
    super.initState();
    // TO DO: Check if it works correctly
    getContactsPermission().then((granted) {
      if (granted == PermissionStatus.authorized) {
        //Provider.of<Contactlist>(context, listen: false).refreshContacts();
        refreshContacts();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Oops!'),
            content: const Text(
                'Looks like permission to read contacts is not granted.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //_allContacts = Provider.of<Contactlist>(context, listen: false).allcontacts;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: !_isLoading
          ? Container(
              child: ListView.builder(
                // check if the ?. expression is needed
                itemCount: _allContacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact = _allContacts[index];
                  var _phonesList = _contact.contact.phones.toList();
                  return _buildListTile(_contact, _phonesList);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      leading: (c.contact.avatar != null)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          //it doesn't work check why
          : CircleAvatar(
              child: Text(
                  (c.contact.displayName[0] +
                      c.contact.displayName[1].toUpperCase()),
                  style: TextStyle(color: Colors.white)),
            ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      //TO DO: activate when the user wants to check multiple contacts
      /* trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
            Provider.of<Contactlist>(context, listen: false).addfav(c);
          }), */
      onTap: () => Navigator.pushNamed(context, '/editcontact',
          arguments: ViewArguments(c, false)),
    );
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts = _contacts
        .map((contact) => CustomContact(
              contact: contact,
              displayname: contact.displayName,
              primaryphone:
                  (contact.phones.isEmpty) ? "" : contact.phones.first.value,
              email: (contact.emails.isEmpty) ? "" : contact.emails.first.value,
            ))
        .toList();
    setState(() {
      _isLoading = false;
    });
  }

  Future<PermissionStatus> getContactsPermission() =>
      SimplePermissions.requestPermission(Permission.ReadContacts);
}
