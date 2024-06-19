import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';


class LocationPermissionCubit extends Cubit<PermissionStatus?> {
  LocationPermissionCubit() : super(null);

  Future<void> checkLocationPermission() async {
    final status = await Permission.location.status;
    emit(status);
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    emit(status);
  }
}
