import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'usage_service.dart';

/// RevenueCat 課金サービス（買い切り ¥2,200 のみ）
///
/// Entitlement ID: "premium"
/// Product ID: "lifetime_2200"（Non-Consumable / Lifetime）
///
/// RevenueCat ダッシュボードで上記を設定してください。
class IAPService {
  IAPService._();
  static final IAPService instance = IAPService._();

  /// RevenueCat Entitlement ID
  static const String entitlementId = 'premium';

  bool _initialized = false;
  bool _isPremium = false;

  /// 有料プランか
  bool get isPremium => _isPremium;

  /// 初期化
  Future<void> init() async {
    if (_initialized) return;

    final apiKey = _apiKeyForPlatform();
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('[IAP] API Key 未設定のためスキップ');
      return;
    }

    try {
      await Purchases.setLogLevel(
        kDebugMode ? LogLevel.debug : LogLevel.error,
      );
      await Purchases.configure(PurchasesConfiguration(apiKey));
      _initialized = true;

      // 初回チェック
      await refreshPremiumStatus();

      // 購入状態の変更をリッスン
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);

      debugPrint('[IAP] 初期化完了 (premium=$_isPremium)');
    } catch (e) {
      debugPrint('[IAP] 初期化エラー: $e');
    }
  }

  /// CustomerInfo 更新コールバック
  void _onCustomerInfoUpdated(CustomerInfo info) {
    _updatePremium(info);
  }

  /// 最新の購入状態を取得
  Future<void> refreshPremiumStatus() async {
    if (!_initialized) return;
    try {
      final info = await Purchases.getCustomerInfo();
      _updatePremium(info);
    } catch (e) {
      debugPrint('[IAP] ステータス取得エラー: $e');
    }
  }

  void _updatePremium(CustomerInfo info) {
    final wasPremium = _isPremium;
    _isPremium = info.entitlements.active.containsKey(entitlementId);
    UsageService.instance.isPremium = _isPremium;
    if (wasPremium != _isPremium) {
      debugPrint('[IAP] Premium 状態変更: $_isPremium');
    }
  }

  /// Offerings を取得（Paywall 表示用）
  Future<Offerings?> getOfferings() async {
    if (!_initialized) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('[IAP] Offerings 取得エラー: $e');
      return null;
    }
  }

  /// パッケージを購入
  Future<bool> purchase(Package package) async {
    if (!_initialized) return false;
    try {
      final result = await Purchases.purchasePackage(package);
      _updatePremium(result.customerInfo);
      return _isPremium;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('[IAP] 購入キャンセル');
      } else {
        debugPrint('[IAP] 購入エラー: $errorCode');
      }
      return false;
    } catch (e) {
      debugPrint('[IAP] 購入エラー: $e');
      return false;
    }
  }

  /// 購入を復元
  Future<bool> restore() async {
    if (!_initialized) return false;
    try {
      final info = await Purchases.restorePurchases();
      _updatePremium(info);
      return _isPremium;
    } catch (e) {
      debugPrint('[IAP] 復元エラー: $e');
      return false;
    }
  }

  /// プラットフォーム別 API Key
  static String? _apiKeyForPlatform() {
    // TODO: RevenueCat ダッシュボードで取得した API Key を設定
    if (Platform.isIOS) return const String.fromEnvironment('RC_IOS_KEY');
    if (Platform.isAndroid) {
      return const String.fromEnvironment('RC_ANDROID_KEY');
    }
    return null;
  }
}
