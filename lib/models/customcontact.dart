import 'package:contacts_service/contacts_service.dart';

class CustomContact {
  final Contact contact;
  bool isChecked;
  int id;

  CustomContact({
    this.contact,
    this.isChecked = false,
    this.id = 0,
  });
}