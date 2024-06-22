import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/utils/app_constants.dart';

class FirestoreRepository {
  final CollectionReference _driversCollection =
      FirebaseFirestore.instance.collection(AppConstants.drivers);
  // final CollectionReference _ordersCollection = FirebaseFirestore.instance.collection(AppConstants.orders);

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
}
