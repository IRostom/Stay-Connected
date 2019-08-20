
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:stay_connected/models/contactlist.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String reloadLabel = 'Reload!';
  final String fireLabel = 'Fire in the hole!';
  final Color floatingButtonColor = Colors.red;
  final IconData reloadIcon = Icons.refresh;
  final IconData fireIcon = Icons.filter_center_focus;

  @override
  _MyHomePageState createState() => new _MyHomePageState(
        floatingButtonLabel: this.fireLabel,
        icon: this.fireIcon,
        floatingButtonColor: this.floatingButtonColor,
      );
}

class _MyHomePageState extends State<MyHomePage> {
  /* List<Contact> _contacts = new List<Contact>(); */
  List<CustomContact> _uiCustomContacts = new List<CustomContact>();

  bool _isLoading = false;
  /* bool _isSelectedContactsView = false; */
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;

  _MyHomePageState({
    this.floatingButtonLabel,
    this.icon,
    this.floatingButtonColor,
  });

  @override
  void initState() {
    super.initState();
    getContactsPermission().then((granted) {
      if (granted) {
        /* refreshContacts(); */
        Provider.of<Contactlist>(context, listen: false).refreshContacts();
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
    _uiCustomContacts = Provider.of<Contactlist>(context, listen: false).favcontacts;
    /* _uiCustomContacts =
        _allContacts.where((contact) => contact.isChecked == true).toList(); */
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _uiCustomContacts?.length,
          itemBuilder: (BuildContext context, int index) {
            CustomContact _contact = _uiCustomContacts[index];
            var _phonesList = _contact.contact.phones.toList();

            return _buildListTile(_contact, _phonesList);
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: floatingButtonColor,
        onPressed: () => Navigator.pushNamed(context, '/allcontacts'),
        icon: Icon(icon),
        label: Text(floatingButtonLabel),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /* void _onSubmit() {
    /* setState(() {
      if (!_isSelectedContactsView) {
        _uiCustomContacts =
            _allContacts.where((contact) => contact.isChecked == true).toList();
        _isSelectedContactsView = true;
        /* _restateFloatingButton(
          widget.reloadLabel,
          Icons.refresh,
          Colors.green,
        ); */
      } else {
        _uiCustomContacts = _allContacts;
        _isSelectedContactsView = false;
        /* _restateFloatingButton(
          widget.fireLabel,
          Icons.filter_center_focus,
          Colors.red,
        ); */
      }
    }); */

    //_uiCustomContacts = _allContacts;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SecondRoute(isLoading: this._isLoading)),
    );
  } */

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      leading: (c.contact.avatar != null)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
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
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
          }),
    );
  }

  /* void _restateFloatingButton(String label, IconData icon, Color color) {
    floatingButtonLabel = label;
    icon = icon;
    floatingButtonColor = color;
  } */

  /* refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  } */

  /* void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    _uiCustomContacts = _allContacts
        .where((contact) => contact.isChecked == true)
        .toList(); //kant fl set state
    setState(() {
      _isLoading = false;
    });
  } */

  Future<bool> getContactsPermission() =>
      SimplePermissions.requestPermission(Permission.ReadContacts);
}