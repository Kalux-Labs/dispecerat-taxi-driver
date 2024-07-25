import 'package:driver/src/models/driver.dart';
import 'package:driver/src/repositories/database_repository.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoCubit extends Cubit<PackageInfo?> {
  AppInfoCubit() : super(null) {
    _initializeAppInfo();
  }

  Future<void> _initializeAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(packageInfo);
  }
}
