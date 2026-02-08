import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API Key の暗号化保存・取得（仕様 1.3: flutter_secure_storage、表示はマスクのみ）
class ApiKeyStorage {
  ApiKeyStorage() : _storage = const FlutterSecureStorage();

  static const _key = 'wan_to_api_key';
  final FlutterSecureStorage _storage;

  Future<void> save(String apiKey) => _storage.write(key: _key, value: apiKey);

  Future<String?> read() => _storage.read(key: _key);

  Future<void> delete() => _storage.delete(key: _key);

  /// 表示用マスク（仕様: ****-**** のみ表示、ログ/クリップボード禁止）
  static String mask(String? value) {
    if (value == null || value.isEmpty) return '';
    return '****-****';
  }
}
