import 'package:flutter/material.dart';
import 'package:stay_connected/models/arguments.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:stay_connected/models/contactlist.dart';
import 'package:provider/provider.dart';

class SecondRoute extends StatefulWidget {
  SecondRoute({
    Key key,
  }) : super(key: key);

  @override
  _SecondRouteState createState() => new _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final bool isLoading = false;
  List<CustomContact> _allContacts = new List<CustomContact>();
  _SecondRouteState();

  @override
  Widget build(BuildContext context) {
    _allContacts = Provider.of<Contactlist>(context, listen: false).allcontacts;
    /* _uiCustomContacts = _allContacts; */
    return Scaffold(
      appBar: AppBar(
        title: Text('All Contacts'),
      ),
      body: !isLoading
          ? Container(
              child: ListView.builder(
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
      /* trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
            Provider.of<Contactlist>(context, listen: false).addfav(c);
          }), */
      onTap: () => Navigator.pushNamed(context, '/editcontact', arguments: ViewArguments(c, false)),
    );
  }
}
