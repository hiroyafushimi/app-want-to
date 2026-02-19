import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AI データ送信同意の永続化サービス。
///
/// Apple Guideline 5.1.1(i)/5.1.2(i) 対応:
/// OCR テキストを OpenAI に送信する前にユーザーの明示的な同意を取得し、
/// その状態を flutter_secure_storage で保持する。
class AiConsentService {
  AiConsentService() : _storage = const FlutterSecureStorage();

  static const _key = 'ai_data_consent_accepted';
  final FlutterSecureStorage _storage;

  /// ユーザーが AI データ送信に同意済みか判定する。
  Future<bool> hasConsented() async {
    final value = await _storage.read(key: _key);
    return value == 'true';
  }

  /// 同意を記録する。
  Future<void> setConsented() async {
    await _storage.write(key: _key, value: 'true');
  }

  /// 同意を撤回する（設定画面から呼び出し）。
  Future<void> revokeConsent() async {
    await _storage.delete(key: _key);
  }
}
