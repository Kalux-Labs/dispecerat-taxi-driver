import 'package:driver/src/models/driver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSessionCubit extends Cubit<Driver?> {
  AppSessionCubit() : super(null);

  void copyWith(Driver? driver){
    emit(driver);
  }
}