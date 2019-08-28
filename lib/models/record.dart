import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name;
  final String phone;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['phone'] != null),
        name = map['name'],
        phone = map['phone'];
       

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$phone>";
}