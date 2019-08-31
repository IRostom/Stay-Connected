import 'package:contacts_service/contacts_service.dart';
import 'package:stay_connected/models/record.dart';

class CustomContact {
  final Contact contact;
  bool isChecked;
  int id;
  DateTime creation;
  int reminderinterval;
  String primaryphone;
  String displayname;

  CustomContact({
    this.contact,
    this.isChecked = false,
    this.id = 0,
    this.creation,
    this.reminderinterval = 7,
    this.primaryphone,
    this.displayname,
  });

   fromrecord(Record record){
    primaryphone = record.phone;
    displayname = record.name;
  }
}
