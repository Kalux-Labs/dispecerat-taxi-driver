import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/utils/app_constants.dart';

class FirestoreRepository {
  final CollectionReference _driversCollection = FirebaseFirestore.instance.collection(AppConstants.drivers);
  // final CollectionReference _ordersCollection = FirebaseFirestore.instance.collection(AppConstants.orders);
  
  Stream<Driver> getDriver(String id) {
    return _driversCollection.doc(id).snapshots().map((snapshot) => Driver.fromDocumentSnapshot(snapshot));
  }

  Stream<Driver> getDriverByPhone(String phone) {
    return _driversCollection.where('phone',isEqualTo: phone).snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return Driver.fromDocumentSnapshot(snapshot.docs.first);
      } else {
        throw Exception('Driver not found');
      }
    });
  }
}