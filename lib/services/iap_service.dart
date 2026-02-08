import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 課金（RevenueCat）ラッパー。
/// 課金UIを非表示にする必要がある場合は [paywallVisible] を false に設定。
class IAPService {
  IAPService({
    required this.paywallVisible,
    String? revenueCatApiKey,
  })  : _revenueCatApiKey = revenueCatApiKey,
        _initialized = false;

  /// 課金・Paywall UI を表示するか。false のときは一切表示しない設計。
  final bool paywallVisible;

  final String? _revenueCatApiKey;
  bool _initialized;

  bool get isAvailable => paywallVisible && _revenueCatApiKey != null && _revenueCatApiKey!.isNotEmpty;

  Future<void> init(String? userId) async {
    if (!isAvailable) return;
    if (_initialized) return;
    await Purchases.setLogLevel(LogLevel.error);
    await Purchases.configure(PurchasesConfiguration(_revenueCatApiKey!));
    if (userId != null && userId.isNotEmpty) {
      await Purchases.logIn(userId);
    }
    _initialized = true;
  }

  /// Offerings を取得（Paywall 表示用）。非表示時は null。
  Future<Offerings?> getOfferings() async {
    if (!isAvailable) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      if (kDebugMode) debugPrint('getOfferings error: $e');
      return null;
    }
  }

  /// 有料プラン所持か（月額/買い切り）。非表示時は false を返すか別ロジックで制御可能。
  Future<bool> get isSubscribed async {
    if (!isAvailable) return false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// プラットフォーム別の RevenueCat API Key を渡す用（iOS/Android で異なる場合）
  static String? apiKeyForPlatform() {
    if (Platform.isIOS) return null; // TODO: 本番で設定
    if (Platform.isAndroid) return null; // TODO: 本番で設定
    return null;
  }
}
