import 'package:stay_connected/models/customcontact.dart';
class ViewArguments {
  final CustomContact customContact;
  final bool expression;
  final String documentID;

  ViewArguments(this.customContact, this.expression, {this.documentID});
}