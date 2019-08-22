import 'package:flutter/material.dart';
import 'package:stay_connected/models/customcontact.dart';

class Contactview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CustomContact c = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact View'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: MemoryImage(c.contact.avatar),
                  radius: 70.0,
                )),
            Container(
                margin: EdgeInsets.all(10.0),
                child: Text(c.contact.displayName)),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: (){},
                child: Text('Call'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: (){},
                child: Text('Set Reminder'),
              ),
            )
          ],
        ),
      ),
    );
  }
}