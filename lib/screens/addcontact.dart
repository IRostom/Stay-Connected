import 'package:flutter/material.dart';
import 'package:stay_connected/models/customcontact.dart';
import 'package:stay_connected/models/contactlist.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/flutter_picker.dart';

class Addcontact extends StatefulWidget {
  Addcontact({
    Key key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => new Addcontactstate();
}

class Addcontactstate extends State<Addcontact> {
  final myController = TextEditingController(text: '7');
  String dropdownvalue = 'One';
  Addcontactstate();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomContact c = ModalRoute.of(context).settings.arguments;
    final phonelist = c.contact.phones.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save Contact to favorites',
            onPressed: () {
              c.isChecked = true;
              Provider.of<Contactlist>(context, listen: false).addfav(c);
              Navigator.pop(context);
            },
          )
        ],
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
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  c.contact.displayName = value;
                  print('Saved');
                },
                initialValue: c.contact.displayName,
                decoration: InputDecoration(
                    labelText: 'Display Name',
                    icon: const Icon(Icons.person),
                    border: OutlineInputBorder()),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                onFieldSubmitted: (String value) {
                  c.primaryphone = value;
                  phonelist[0].value = value;
                  print('Saved');
                },
                initialValue: phonelist[0].value,
                decoration: InputDecoration(
                    labelText: 'Phone',
                    icon: const Icon(Icons.phone),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: myController,
                decoration: InputDecoration(
                    labelText: 'Reminder Interval',
                    icon: const Icon(Icons.schedule),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: (){
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
                          c.reminderinterval = value[0];
                          myController.text = value[0].toString();
                        });
                      }).showDialog(context);
                      },
                      ),),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
