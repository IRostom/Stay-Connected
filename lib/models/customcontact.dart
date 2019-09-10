import 'package:contacts_service/contacts_service.dart';
import 'package:stay_connected/models/record.dart';

class CustomContact {
  Contact contact;
  String displayname;
  String primaryphone;
  String email;
  int reminderinterval;
  DateTime creationdate;
  DateTime lastcontacted;
  int connects;
  int notificationID;
  String docID; //taken from record data
  //bool isChecked;
  //int id;

  CustomContact({
    this.contact,
    this.displayname,
    this.primaryphone,
    this.email,
    this.reminderinterval = 7,
    this.creationdate,
    this.lastcontacted,
    this.connects,
    this.notificationID,
    this.docID
  });

  fromrecord(Record record) {
    displayname = record.displayname;
    primaryphone = record.primaryphone;
    email = record.email;
    reminderinterval = record.reminderinterval;
    creationdate = record.creationdate;
    lastcontacted = record.lastcontacted;
    connects = record.connects;
    notificationID = record.notificationID;
    docID = record.docID;
  }
}
