import 'package:driver/src/models/driver.dart';
import 'package:driver/src/repositories/database_repository.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSessionCubit extends Cubit<Driver?> {
  final FirestoreRepository _firestoreRepository;
  final DatabaseRepository _databaseRepository;

  AppSessionCubit(
      {required FirestoreRepository firestoreRepository,
      required DatabaseRepository databaseRepository})
      : _firestoreRepository = firestoreRepository,
        _databaseRepository = databaseRepository,
        super(null);

  Future<void> initializeDriver(User user) async {
    Driver? driver = await _firestoreRepository.getDriver(user.uid);
    emit(driver);
  }

  Future<void> initializeDriverByPhoneNumber(User user) async {
    Driver? driver =
        await _firestoreRepository.getDriverByPhone(user.phoneNumber!);
    emit(driver);
  }

  Future<void> updateDriverConnection(bool online) async {
    await _firestoreRepository.updateDriverConnection(state!, online);
    await _databaseRepository.updateDriver(state!.id, {"online": online});
    emit(state?.copyWith(online: online));
  }
}
