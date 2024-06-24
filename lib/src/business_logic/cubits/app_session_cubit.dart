import 'package:driver/src/models/driver.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSessionCubit extends Cubit<Driver?> {
  final FirestoreRepository _firestoreRepository;

  AppSessionCubit({required FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(null);

  Future<void> initializeDriver(User user) async {
    Driver? driver = await _firestoreRepository.getDriver(user.uid);
    emit(driver);
  }
  Future<void> initializeDriverByPhoneNumber(User user) async {
    Driver? driver = await _firestoreRepository.getDriverByPhone(user.phoneNumber!);
    emit(driver);
  }
}
