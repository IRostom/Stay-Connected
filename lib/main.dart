import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stay_connected/screens/contact.dart';
import 'package:stay_connected/screens/savedcontacts.dart';
import 'package:stay_connected/screens/addcontact.dart';
import 'package:stay_connected/screens/editcontact.dart';
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
        '/': (context) => MyHomePage(title: 'Custom contact selection'), //saved contacts
        '/allcontacts': (context) => SecondRoute(),  // all contacts
        '/contactview': (context) => Contactview(),
        '/editcontact': (context) => Addcontact(),
      },
      ),
    );
  }
}