import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:stay_connected/models/arguments.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:stay_connected/models/record.dart';

class Contactview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Record record = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text('Contact View'), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Contact',
            onPressed: () {
              Contact contact = new Contact();
              CustomContact customContact = new CustomContact(contact: contact);
              customContact.fromrecord(record);
              Navigator.pushNamed(context, '/editcontact',
                  arguments: ViewArguments(customContact, true,
                      documentID: record.docID));
            })
      ]),
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
                margin: EdgeInsets.all(10.0), child: Text(record.displayname)),
            Container(
                margin: EdgeInsets.all(10.0), child: Text(record.primaryphone)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  iconbutton(Icons.call),
                  iconbutton(Icons.email),
                  iconbutton(Icons.sms)
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget iconbutton(IconData iconData) {
    return RaisedButton(
      onPressed: () {
        print('press me again, daddy!');
      },
      shape: CircleBorder(),
      child: Icon(iconData, size: 30.0),
    );
  }
}

Widget viewdata(String label, dynamic value, IconData iconData){
return Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  print('Saved');
                },
                readOnly: true,
                initialValue:value,
                decoration: InputDecoration(
                    labelText: label,
                    prefixIcon: Icon(iconData),
                    border: OutlineInputBorder()),
                textCapitalization: TextCapitalization.words,
              ),
            );
}
