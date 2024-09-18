import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoCubit extends Cubit<PackageInfo?> {
  AppInfoCubit() : super(null) {
    _initializeAppInfo();
  }

  Future<void> _initializeAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(packageInfo);
  }
}
