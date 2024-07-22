import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/utils/app_constants.dart';
import 'package:driver/src/models/order.dart' as driver_order;

class FirestoreRepository {
  final CollectionReference _driversCollection =
      FirebaseFirestore.instance.collection(AppConstants.drivers);
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection(AppConstants.orders);

  Future<Driver?> getDriverByPhone(String phone) async {
    QuerySnapshot querySnapshot =
        await _driversCollection.where('phone', isEqualTo: phone).get();
    if (querySnapshot.docs.isNotEmpty) {
      return Driver.fromDocumentSnapshot(querySnapshot.docs.first);
    }
    return null;
  }

  Future<Driver?> getDriver(String id) async {
    DocumentSnapshot documentSnapshot = await _driversCollection.doc(id).get();
    if (documentSnapshot.exists) {
      return Driver.fromDocumentSnapshot(documentSnapshot);
    }
    return null;
  }

  Future<driver_order.Order?> getOrder(String id) async {
    DocumentSnapshot documentSnapshot = await _ordersCollection.doc(id).get();
    if (documentSnapshot.exists) {
      return driver_order.Order.fromDocumentSnapshot(documentSnapshot);
    }
    return null;
  }

  Stream<Driver> getDriverStream(String id) {
    return _driversCollection.doc(id).snapshots().map((documentSnapshot) {
      return Driver.fromDocumentSnapshot(documentSnapshot);
    });
  }

  Future<void> acceptOrder(String orderId, String driverId) async {
    await _ordersCollection.doc(orderId).update({'status': 'accepted'});
    await _driversCollection.doc(driverId).update({'available': false});
  }

  Future<void> completeOrder(String orderId, String driverId) async {
    await _ordersCollection.doc(orderId).update({'status': 'completed'});
  }

  Future<void> updateDriverConnection(Driver driver, bool online) async {
    await _driversCollection.doc(driver.id).update({'online': online});
  }
}
