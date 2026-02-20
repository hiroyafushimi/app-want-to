import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../utils/app_logger.dart';
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

  static const _log = AppLogger('IAP');
  bool _initialized = false;
  bool _isPremium = false;

  /// 有料プランか
  bool get isPremium => _isPremium;

  /// 初期化
  Future<void> init() async {
    if (_initialized) return;

    final apiKey = _apiKeyForPlatform();
    if (apiKey == null || apiKey.isEmpty) {
      _log.info('API Key 未設定のためスキップ');
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

      _log.info('初期化完了 (premium=$_isPremium)');
    } catch (e) {
      _log.error('初期化エラー', e);
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
      _log.error('ステータス取得エラー', e);
    }
  }

  void _updatePremium(CustomerInfo info) {
    final wasPremium = _isPremium;
    _isPremium = info.entitlements.active.containsKey(entitlementId);
    UsageService.instance.isPremium = _isPremium;
    if (wasPremium != _isPremium) {
      _log.info('Premium 状態変更: $_isPremium');
    }
  }

  /// Offerings を取得（Paywall 表示用）
  Future<Offerings?> getOfferings() async {
    if (!_initialized) {
      _log.error('Offerings 取得失敗: 未初期化');
      return null;
    }
    try {
      final offerings = await Purchases.getOfferings();
      final pkgs = offerings.current?.availablePackages
          .map((p) => '${p.identifier}(${p.storeProduct.identifier})')
          .toList();
      _log.info('Offerings 取得: '
          'all=${offerings.all.keys.toList()}, '
          'current=${offerings.current?.identifier ?? "null"}, '
          'packages=$pkgs');
      return offerings;
    } catch (e) {
      _log.error('Offerings 取得エラー', e);
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
        _log.info('購入キャンセル');
      } else {
        _log.error('購入エラー: $errorCode');
      }
      return false;
    } catch (e) {
      _log.error('購入エラー', e);
      return false;
    }
  }

  /// リソース解放（リスナー解除）
  void dispose() {
    if (!_initialized) return;
    Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdated);
  }

  /// 購入を復元
  Future<bool> restore() async {
    if (!_initialized) return false;
    try {
      final info = await Purchases.restorePurchases();
      _updatePremium(info);
      return _isPremium;
    } catch (e) {
      _log.error('復元エラー', e);
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
