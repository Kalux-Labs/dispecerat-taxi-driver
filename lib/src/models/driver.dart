import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Driver {
  final String id;
  final String? phone;
  final int? number;
  final double? lat;
  final double? long;
  final String? orderId;
  final bool? available;

  Driver(
      {required this.id,
      this.phone,
      this.number,
      this.lat,
      this.long,
      this.orderId,
      this.available});

  factory Driver.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<String, dynamic>;
    return Driver(
        id: snapshot.id,
        phone: data['phone'],
        number: data['number'],
        lat: data['lat'],
        long: data['long'],
        orderId: data['orderId'],
        available: data['available']);
  }

  factory Driver.fromDataSnapshot(DataSnapshot snapshot) {
    assert(snapshot.exists, 'Snapshot does not exist');
    assert(
        snapshot.value is Map<dynamic, dynamic>, 'Snapshot value is not a map');

    Map data = snapshot.value as Map<dynamic, dynamic>;
    return Driver(
        id: snapshot.key!,
        phone: data['phone'] as String?,
        number: data['number'] as int?,
        lat: data['lat'] as double?,
        long: data['long'] as double?,
        orderId: data['orderId'] as String?,
        available: data['available'] as bool?);
  }
}
