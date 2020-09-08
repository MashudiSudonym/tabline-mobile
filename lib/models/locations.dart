import 'package:cloud_firestore/cloud_firestore.dart';

class Locations {
  final String address;
  final String image;
  final GeoPoint location;
  final String name;
  final String phone;
  final String uid;

  Locations.fromMap(Map<String, dynamic> map)
      : assert(map['address'] != null),
        assert(map['image'] != null),
        assert(map['location'] != null),
        assert(map['name'] != null),
        assert(map['phone'] != null),
        assert(map['uid'] != null),
        address = map['address'],
        image = map['image'],
        location = map['location'],
        name = map['name'],
        phone = map['phone'],
        uid = map['uid'];

  Locations.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());
}
