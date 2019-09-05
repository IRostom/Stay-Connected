import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stay_connected/models/GoogleAuthentication.dart';
import 'package:stay_connected/models/arguments.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:stay_connected/models/record.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Editcontact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new Addcontactstate();
}

class Addcontactstate extends State<Editcontact> {
  final myController = TextEditingController(text: '7');
  Record record;
  CustomContact contact;
  bool update = false;
  FirebaseUser firebaseUser;
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = authService.user.listen((FirebaseUser u) {
      firebaseUser = u;
      print(u.displayName);
    });
  }

  @override
  void dispose() {
    myController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ViewArguments arguments = ModalRoute.of(context).settings.arguments;
    CustomContact customContact = arguments.customContact;
    bool updatecontact = arguments.expression;
    print('build started');
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),
        actions: <Widget>[
          IconButton(
            icon: updatecontact ? Icon(Icons.update) : Icon(Icons.add_circle),
            tooltip: updatecontact ? 'Save contact' : 'Update contact',
            onPressed: () {
              if (updatecontact) {
                updatedoc(arguments.documentID, customContact);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else {
                updatedb(customContact, context);
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            /* Container(
                margin: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: MemoryImage(customContact.contact.avatar),
                  radius: 70.0,
                )), */
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  customContact.displayname = value;
                  print('Saved');
                },
                initialValue: customContact.displayname,
                decoration: InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder()),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  customContact.primaryphone = value;
                },
                initialValue: customContact.primaryphone,
                decoration: InputDecoration(
                    labelText: 'Primary Phone',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  customContact.email = value;
                },
                initialValue: customContact.email,
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  labelText: 'Reminder Interval',
                  prefixIcon: const Icon(Icons.schedule),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      new Picker(
                          adapter: NumberPickerAdapter(data: [
                            NumberPickerColumn(begin: 0, end: 100),
                          ]),
                          delimiter: [
                            PickerDelimiter(
                                child: Container(
                              alignment: Alignment.center,
                            ))
                          ],
                          hideHeader: true,
                          title: new Text("Please Select"),
                          onConfirm: (Picker picker, List value) {
                            setState(() {
                              customContact.reminderinterval = value[0];
                              myController.text = value[0].toString();
                            });
                          }).showDialog(context);
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createdoc(CustomContact customcontact, {bool newdoc: false}) {
    String documentID = !newdoc ? customcontact.contact.displayName : null;
    Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .collection('contacts')
        .document(documentID)
        .setData({
      'displayname': customcontact.contact.displayName,
      'primaryphone': customcontact.primaryphone,
      'email': customcontact.email,
      'reminder interval': customcontact.reminderinterval,
      'creation date': DateTime.now()
    });
  }

  void updatedoc(String documentID, CustomContact customcontact) {
    Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .collection('contacts')
        .document(documentID)
        .updateData({
      'displayname': customcontact.displayname,
      'primaryphone': customcontact.primaryphone,
      'email': customcontact.email,
      'reminder interval': customcontact.reminderinterval
    });
    print(customcontact.primaryphone);
  }

  void updatedb(CustomContact customContact, BuildContext context) {
    Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .collection('contacts')
        .where('displayname',
            isEqualTo: customContact.contact.displayName.toString())
        .getDocuments()
        .then((data) {
      if (data.documents.length == 0) {
        createdoc(customContact);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } else if (data.documents.length == 1) {
        DocumentSnapshot documentSnapshot = data.documents[0];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Conflict!'),
            content: const Text(
                'Another contact with the same name exists in your database!'),
            actions: <Widget>[
              FlatButton(
                  child: const Text('Merge'),
                  onPressed: () {
                    updatedoc(documentSnapshot.documentID, customContact);
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }),
              FlatButton(
                  child: const Text('Create new'),
                  onPressed: () {
                    createdoc(customContact, newdoc: true);
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  })
            ],
          ),
        );
      }
    });
  }
}
