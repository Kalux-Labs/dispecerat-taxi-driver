import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/utils/app_constants.dart';

class AuthenticationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Driver?> getDriverByPhone(String phone) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(AppConstants.drivers)
        .where('phone', isEqualTo: phone)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return Driver.fromDocumentSnapshot(querySnapshot.docs.first);
    }
    return null;
  }

  Future<Driver?> getDriverById(String id) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(AppConstants.drivers).doc(id).get();
    if (documentSnapshot.exists) {
      return Driver.fromDocumentSnapshot(documentSnapshot);
    }
    return null;
  }
}
