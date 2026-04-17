import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

class SecureStorage {
  final storage = FlutterSecureStorage();
  static const _authKey = 'token';

  Future<void> saveToken(String token) async {
    await storage.write(key: _authKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: _authKey);
  }

  Future<void> clearToken() async {
    await storage.delete(key: _authKey);
  }
}
