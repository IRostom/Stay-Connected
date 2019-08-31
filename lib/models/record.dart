import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name;
  final String phone;
  final DocumentReference reference;
  final String docID;

  Record.fromMap(Map<String, dynamic> map, {this.reference, this.docID})
      : assert(map['name'] != null),
        assert(map['phone'] != null),
        name = map['name'],
        phone = map['phone'];
       

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference, docID: snapshot.documentID);

  @override
  String toString() => "Record<$name:$phone>";

  String getID() => docID;
}