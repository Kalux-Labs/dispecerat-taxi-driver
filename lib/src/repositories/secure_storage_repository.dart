import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    final value = await _secureStorage.read(key: key);
    return value;
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
  }
}