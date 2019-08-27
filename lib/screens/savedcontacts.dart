import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:stay_connected/models/contactlist.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_permissions/simple_permissions.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String fireLabel = 'Contacts';
  final Color floatingButtonColor = Colors.blue;
  final IconData fireIcon = Icons.add_circle;

  @override
  _MyHomePageState createState() => new _MyHomePageState(
        floatingButtonLabel: this.fireLabel,
        icon: this.fireIcon,
        floatingButtonColor: this.floatingButtonColor,
      );
}

class _MyHomePageState extends State<MyHomePage> {
  List<CustomContact> _uiCustomContacts = new List<CustomContact>();
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
      if (granted == PermissionStatus.authorized) {
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
    _uiCustomContacts =
        Provider.of<Contactlist>(context, listen: false).favcontacts;

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
      subtitle: Text(c.primaryphone ?? ""),/* list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''), */
      onTap: () => Navigator.pushNamed(context, '/contactview', arguments: c),
    );
  }

  Future<PermissionStatus> getContactsPermission() =>
      SimplePermissions.requestPermission(Permission.ReadContacts);
}
