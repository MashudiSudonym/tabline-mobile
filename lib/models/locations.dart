import 'package:cloud_firestore/cloud_firestore.dart';

class Locations {
  final String address;
  final String close;
  final String image;
  final GeoPoint location;
  final String name;
  final String open;
  final String phone;
  final String uid;

  Locations.fromMap(Map<String, dynamic> map)
      : assert(map['address'] != null),
        assert(map['open'] != null),
        assert(map['image'] != null),
        assert(map['location'] != null),
        assert(map['name'] != null),
        assert(map['open'] != null),
        assert(map['phone'] != null),
        assert(map['uid'] != null),
        address = map['address'],
        close = map['close'],
        image = map['image'],
        location = map['location'],
        name = map['name'],
        open = map['open'],
        phone = map['phone'],
        uid = map['uid'];

  Locations.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());
}
