import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stay_connected/models/contactlist.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stay_connected/models/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_connected/models/GoogleAuthentication.dart';
import 'package:stay_connected/screens/user.dart';


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
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;
  FirebaseUser firebaseUser;
  StreamSubscription streamSubscription;

  _MyHomePageState({
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
    trysignin();
    streamSubscription = authService.firebaseuser
        .listen((firebaseuser) => setState(() => firebaseUser = firebaseuser));
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.title), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Contact',
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
              : Text('Sign in')),
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
      title: Text(record.name ?? ""),
      subtitle: Text(record.phone ?? ""),
      /* list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''), */
      onTap: () =>
          Navigator.pushNamed(context, '/contactview', arguments: record),
    );
  }

  Future<PermissionStatus> getContactsPermission() =>
      SimplePermissions.requestPermission(Permission.ReadContacts);
}
