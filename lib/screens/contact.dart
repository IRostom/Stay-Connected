import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:stay_connected/models/record.dart';

class Contactview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Record record = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact View'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Contact',
            onPressed: () {
              Contact contact = new Contact();
              CustomContact customContact = new CustomContact(contact: contact);
              //contact.fromrecord(record);
              customContact.primaryphone = record.phone;
              customContact.contact.displayName = record.name;
              Navigator.pushNamed(context, '/editcontact', arguments: customContact);
            }
          )
          ]
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            /* Container(
                margin: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: MemoryImage(c.contact.avatar),
                  radius: 70.0,
                )), */
            Container(
                margin: EdgeInsets.all(10.0),
                child: Text(record.name)),
            Container(
                margin: EdgeInsets.all(10.0),
                child: Text(record.phone)),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {},
                child: Text('Call'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {},
                child: Text('Set Reminder'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
