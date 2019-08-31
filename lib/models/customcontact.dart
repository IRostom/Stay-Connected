import 'package:contacts_service/contacts_service.dart';
import 'package:stay_connected/models/record.dart';

class CustomContact {
  final Contact contact;
  bool isChecked;
  int id;
  DateTime creation;
  int reminderinterval;
  String primaryphone;

  CustomContact({
    this.contact,
    this.isChecked = false,
    this.id = 0,
    this.creation,
    this.reminderinterval = 7,
    this.primaryphone,
  });

  /* CustomContact.fromrecord(Record record) {
    this.contact = Contact();
    this.primaryphone = record.phone;
    this.contact.displayName = record.name;
  } */

   /* fromrecord(Record record){
    primaryphone = record.phone;
    this.contact.displayName = record.name;
  } */
}
