import 'package:driver/src/models/driver.dart';
import 'package:driver/src/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> updateDriver(String id, Map<String, dynamic> map) async {
    DatabaseReference driverRef = _database.ref('${AppConstants.drivers}/$id');
    await driverRef.update(map);
  }

  Stream<Driver> getDriverStream(String id) {
    DatabaseReference driverRef = _database.ref('${AppConstants.drivers}/$id');
    return driverRef.onValue.map((event) {
      return Driver.fromDataSnapshot(event.snapshot);
    });
  }
}
