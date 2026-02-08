/// アプリ全体の設定。課金UI非表示など、必要に応じてリモート設定に差し替え可能。
class AppConfig {
  AppConfig._();

  /// 課金・Paywall UI を表示するか。false のときは一切表示しない。
  /// リモート設定や Feature Flag で切り替える想定。
  static const bool paywallVisible = true;

  /// RevenueCat API Key（本番で設定。空なら RevenueCat は初期化しない）
  static const String? revenueCatApiKey = null;
}
