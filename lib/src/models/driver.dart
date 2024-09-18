import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Driver {
  final String id;
  final String phone;
  final int number;
  final bool available;
  final bool online;
  final String? orderId;
  final String? name;
  final String? fcmToken;

  Driver({
    required this.id,
    required this.phone,
    required this.number,
    required this.available,
    required this.online,
    this.orderId,
    this.name,
    this.fcmToken,
  });

  factory Driver.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final Map<String, dynamic> data = snapshot.data()!;
    return Driver(
      id: snapshot.id,
      phone: data['phone'] as String,
      number: data['number'] as int,
      orderId: data['orderId'] as String,
      available: data['available'] as bool? ?? false,
      online: data['online'] as bool,
      name: data['name'] as String,
      fcmToken: data['fcmToken'] as String,
    );
  }

  factory Driver.fromDataSnapshot(DataSnapshot snapshot) {
    assert(snapshot.exists, 'Snapshot does not exist');
    assert(
      snapshot.value is Map<dynamic, dynamic>,
      'Snapshot value is not a map',
    );

    final Map<String, dynamic> data = snapshot.value! as Map<String, dynamic>;
    return Driver(
      id: snapshot.key!,
      phone: data['phone'] as String,
      number: data['number'] as int,
      available: data['available'] as bool,
      online: data['online'] as bool,
      orderId: data['orderId'] as String?,
      name: data['name'] as String?,
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Driver copyWith({
    String? phone,
    int? number,
    bool? available,
    bool? online,
    String? orderId,
    String? name,
    String? fcmToken,
  }) {
    return Driver(
      id: id,
      phone: phone ?? this.phone,
      number: number ?? this.number,
      available: available ?? this.available,
      online: online ?? this.online,
      orderId: orderId ?? this.orderId,
      name: name ?? this.name,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
