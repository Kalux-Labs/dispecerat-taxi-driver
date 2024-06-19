import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/src/utils/enums/order_status.dart';
import 'package:driver/src/utils/extensions.dart';

class Order {
  final String id;
  final String placeId;
  final DateTime createdAt;
  final String details;
  final OrderStatus status;
  final String phone;
  final String driverId;

  Order(
      {required this.id,
      required this.placeId,
      required this.createdAt,
      required this.details,
      required this.status,
      required this.phone,
      required this.driverId});

  Order copyWith({
    String? id,
    String? placeId,
    DateTime? createdAt,
    String? details,
    OrderStatus? status,
    String? phone,
    String? driverId
}) {
    return Order(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      createdAt: createdAt ?? this.createdAt,
      details: details ?? this.details,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      driverId: driverId ?? this.driverId
    );
  }

  factory Order.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<String, dynamic>;

    return Order(
      id: snapshot.id,
      placeId: data['placeId'],
      createdAt: data['createdAt'],
      details: data['details'],
      status: (data['status'] as String?).toOrderStatus(),
      phone: data['phone'],
      driverId: data['driverId']
    );
  }
}
