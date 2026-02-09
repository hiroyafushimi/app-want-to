import 'dart:io';

import 'package:flutter/services.dart';

/// Share Extension が App Group に書き出したデバッグログをメインアプリから読む（iOS のみ）
class ShareDebugLogService {
  static const _channel = MethodChannel('want_to/share_debug_log');

  /// iOS のときのみネイティブからログ文字列を取得。それ以外は空文字。
  static Future<String> getShareExtensionDebugLog() async {
    if (!Platform.isIOS) return '(iOS のみ)';
    try {
      final String? log = await _channel.invokeMethod<String>('getShareExtensionDebugLog');
      return log ?? '(取得失敗)';
    } on PlatformException catch (e) {
      return '(エラー: ${e.code}) ${e.message}';
    }
  }
}
