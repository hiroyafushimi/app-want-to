import 'package:flutter/foundation.dart';

/// 統一ログ出力ユーティリティ。
///
/// 各サービスで `static const _log = AppLogger('TAG')` として使う。
/// タグ名で grep できるよう `[TAG]` 形式を統一する。
class AppLogger {
  const AppLogger(this.tag);

  final String tag;

  void info(String message) => debugPrint('[$tag] $message');

  void error(String message, [Object? error]) {
    debugPrint('[$tag] ERROR: $message');
    if (error != null) debugPrint('[$tag] $error');
  }
}
