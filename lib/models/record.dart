import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final DocumentReference reference;
  final String docID;
  final String displayname;
  final String primaryphone;
  final String email;
  final int reminderinterval;
  final DateTime creationdate;
  final DateTime lastcontacted;
  final int connects;
  final int notificationID;


//TO DO: if it's null import empty string
  Record.fromMap(Map<String, dynamic> map, {this.reference, this.docID})
      : //assert(map['displayname'] != null),
        //assert(map['primaryphone'] != null),
        displayname = map['displayname'],
        primaryphone = map['primaryphone'],
        email = map['email'],
        reminderinterval = map['reminderinterval'],
        creationdate = map['creationdate'],
        lastcontacted = map['lastcontacted'],
        connects = map['connects'],
        notificationID = map['notificationid'];


  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data,
            reference: snapshot.reference, docID: snapshot.documentID);


// TO DO : add other fields
  @override
  String toString() => "Record<$displayname:$primaryphone>";

  String getID() => docID;
}
