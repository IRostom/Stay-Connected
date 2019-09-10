import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stay_connected/screens/contact.dart';
import 'package:stay_connected/screens/savedcontacts.dart';
import 'package:stay_connected/screens/addcontact.dart';
import 'package:stay_connected/screens/editcontact.dart';
import 'package:stay_connected/models/contactlist.dart';
import 'package:stay_connected/screens/user.dart';
import 'package:stay_connected/screens/temp.dart';

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
          '/user': (context) => Userview(),
          '/': (context) => SavedContact(), //saved contacts
          '/allcontacts': (context) => Addcontact(),
          '/contactview': (context) => Contactview(),
          '/editcontact': (context) => Editcontact(),
          '/temp': (context) => Temporary(),
        },
      ),
    );
  }
}
