import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stay_connected/screens/contact-view.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:stay_connected/models/customcontact.dart';
import 'package:stay_connected/screens/savedcontacts.dart';
import 'package:stay_connected/screens/allcontacts.dart';
import 'package:stay_connected/models/contactlist.dart';


/* List<CustomContact> _uiCustomContacts = List<CustomContact>();
List<CustomContact> _allContacts = List<CustomContact>(); */

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return ChangeNotifierProvider(
      builder: (context) => Contactlist(),
      child: MaterialApp(
        title: 'Stay Connected',
        theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
        initialRoute: '/',
        routes: {
        '/': (context) => MyHomePage(title: 'Custom contact selection'),
        '/allcontacts': (context) => SecondRoute(),
        '/contactview': (context) => Contactview(),
      },
      ),
    );
  }
}