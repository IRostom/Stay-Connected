import 'package:contacts_service/contacts_service.dart';

class CustomContact {
  final Contact contact;
  bool isChecked;
  int id;
  DateTime creation;
  int reminderinterval;

  CustomContact({
    this.contact,
    this.isChecked = false,
    this.id = 0,
    this.creation,
    this.reminderinterval = 7
  });
}
