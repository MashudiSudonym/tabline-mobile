import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tabline/models/locations.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Stream<QuerySnapshot> loadAllLocationData() {
  return _firestore.collection('locations').snapshots();
}

List<Locations> listLocations(QuerySnapshot snapshot) {
  return snapshot.docs.map(
    (DocumentSnapshot doc) {
      return Locations.fromSnapshot(doc);
    },
  ).toList();
}

Future<Locations> getLocationById(String uid) {
  return _firestore
      .collection('locations')
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) => Locations.fromSnapshot(doc))
      .catchError((e) => print(e));
}
