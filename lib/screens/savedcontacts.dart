import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:stay_connected/models/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_connected/models/GoogleAuthentication.dart';
import 'package:stay_connected/screens/user.dart';

class SavedContact extends StatefulWidget {
  final String fireLabel = 'Contacts';
  final Color floatingButtonColor = Colors.blue;
  final IconData fireIcon = Icons.add_circle;

  @override
  _SavedContactState createState() => new _SavedContactState(
        floatingButtonLabel: this.fireLabel,
        icon: this.fireIcon,
        floatingButtonColor: this.floatingButtonColor,
      );
}

class _SavedContactState extends State<SavedContact> {
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;
  FirebaseUser firebaseUser;
  StreamSubscription streamSubscription;

  _SavedContactState({
    this.floatingButtonLabel,
    this.icon,
    this.floatingButtonColor,
  });

  void trysignin() async {
    FirebaseUser _firebaseuser;
    _firebaseuser = await authService.trySignInWithGoogle();
    if (_firebaseuser == null) {
      // TO DO : return to this view after sigining in and getting credentials.
      Navigator.push(context,
          MaterialPageRoute<FirebaseUser>(builder: (context) => Userview()));
    }
  }

  @override
  void initState() {
    super.initState();
    trysignin();
    streamSubscription = authService.firebaseuser.listen((firebaseuser) {
      setState(() => firebaseUser = firebaseuser);
      print('new activity');
    });

    print("broadcast: " + authService.firebaseuser.isBroadcast.toString());
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    print(" savedcontacts disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title:Text('Saved Contacts'), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'User view',
            onPressed: () {
              Navigator.pushNamed(context, '/user');
            })
      ]),
      body: Container(
          child: (firebaseUser != null)
              ? StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('users')
                      .document(firebaseUser.uid)
                      .collection('contacts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return _buildList(context, snapshot.data.documents);
                  },
                )
              : Text('Sign in to connect with your contacts')),

      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: floatingButtonColor,
        onPressed: () => Navigator.pushNamed(context, '/allcontacts'),
        icon: Icon(icon),
        label: Text(floatingButtonLabel),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListTile(context, snapshot[index]);
        });
  }

  ListTile _buildListTile(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return ListTile(
      /*  leading: (c.contact.avatar != null)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          : CircleAvatar(
              child: Text(
                  (c.contact.displayName[0] +
                      c.contact.displayName[1].toUpperCase()),
                  style: TextStyle(color: Colors.white)),
            ), */
      title: Text(record.displayname ?? ""),
      subtitle: Text(record.primaryphone ?? ""),
      /* list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''), */
      onTap: () {
        CustomContact customContact = CustomContact().fromrecord(record);
        return Navigator.pushNamed(context, '/contactview', arguments: customContact);
      },
    );
  }
}
