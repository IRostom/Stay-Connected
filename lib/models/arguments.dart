import 'package:stay_connected/models/customcontact.dart';
class ViewArguments {
  final CustomContact customContact;
  final bool expression; // false yb2a by7ot contact gded
  final String documentID;

  ViewArguments(this.customContact, this.expression, {this.documentID});
}