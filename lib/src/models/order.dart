import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/src/models/place.dart';
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
  final GeoPoint coordinates;
  final Place? place;

  Order({
    required this.id,
    required this.placeId,
    required this.createdAt,
    required this.details,
    required this.status,
    required this.phone,
    required this.driverId,
    required this.coordinates,
    this.place,
  });

  Order copyWith(
      {String? placeId,
      DateTime? createdAt,
      String? details,
      OrderStatus? status,
      String? phone,
      String? driverId,
      Place? place,
      GeoPoint? coordinates}) {
    return Order(
        id: id,
        placeId: placeId ?? this.placeId,
        createdAt: createdAt ?? this.createdAt,
        details: details ?? this.details,
        status: status ?? this.status,
        phone: phone ?? this.phone,
        driverId: driverId ?? this.driverId,
        place: place ?? this.place,
        coordinates: coordinates ?? this.coordinates);
  }

  factory Order.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<String, dynamic>;

    return Order(
        id: snapshot.id,
        placeId: data['placeId'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(data['created_at']),
        details: data['details'],
        status: (data['status'] as String?).toOrderStatus(),
        phone: data['phone'],
        driverId: data['driverId'],
        coordinates: data['coordinates'] as GeoPoint);
  }
}
