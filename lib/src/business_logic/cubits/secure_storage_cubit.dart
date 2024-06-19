import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageCubit extends Cubit<String?> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SecureStorageCubit() : super(null);

  Future<void> saveData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    emit(value);
  }

  Future<void> readData(String key) async {
    final value = await _secureStorage.read(key: key);
    emit(value);
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
    emit(null);
  }
}