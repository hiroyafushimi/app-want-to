import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../screens/paywall_screen.dart';

/// 日次使用回数管理サービス（仕様 1.4: 無料=OCR 5回/日, AI 1回/日）
///
/// SharedPreferences ではなくメモリ+日付チェックで軽量実装。
/// アプリ再起動でリセットされるが、MVP では許容。
/// 本番では SharedPreferences or ローカル DB に永続化する。
class UsageService {
  UsageService._();
  static final UsageService instance = UsageService._();

  // ── 無料プラン上限 ──
  static const int freeOcrLimit = 5;
  static const int freeAiLimit = 1;

  // ── 内部カウンター ──
  int _ocrCount = 0;
  int _aiCount = 0;
  String _dateKey = '';

  /// 有料プラン所持フラグ（IAPService と連携して更新）
  bool isPremium = false;

  /// 今日の日付キー
  String get _today {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// 日付が変わったらカウンターをリセット
  void _resetIfNewDay() {
    final today = _today;
    if (_dateKey != today) {
      _ocrCount = 0;
      _aiCount = 0;
      _dateKey = today;
      debugPrint('[Usage] 日付リセット: $today');
    }
  }

  // ── OCR ──

  /// OCR の残り回数
  int get remainingOcr {
    if (isPremium) return -1; // 無制限
    _resetIfNewDay();
    return (freeOcrLimit - _ocrCount).clamp(0, freeOcrLimit);
  }

  /// OCR が実行可能か
  bool get canUseOcr {
    if (isPremium) return true;
    _resetIfNewDay();
    return _ocrCount < freeOcrLimit;
  }

  /// OCR 使用をカウント。成功時 true、上限到達で false。
  bool consumeOcr() {
    if (isPremium) return true;
    _resetIfNewDay();
    if (_ocrCount >= freeOcrLimit) return false;
    _ocrCount++;
    debugPrint('[Usage] OCR 使用: $_ocrCount/$freeOcrLimit');
    return true;
  }

  // ── AI ──

  /// AI の残り回数
  int get remainingAi {
    if (isPremium) return -1; // 無制限
    _resetIfNewDay();
    return (freeAiLimit - _aiCount).clamp(0, freeAiLimit);
  }

  /// AI が実行可能か
  bool get canUseAi {
    if (isPremium) return true;
    _resetIfNewDay();
    return _aiCount < freeAiLimit;
  }

  /// AI 使用をカウント。成功時 true、上限到達で false。
  bool consumeAi() {
    if (isPremium) return true;
    _resetIfNewDay();
    if (_aiCount >= freeAiLimit) return false;
    _aiCount++;
    debugPrint('[Usage] AI 使用: $_aiCount/$freeAiLimit');
    return true;
  }

  // ── UI 用ヘルパー ──

  /// 回数制限到達時のダイアログを表示
  static Future<void> showLimitDialog(
    BuildContext context, {
    required String featureName,
    required int dailyLimit,
  }) {
    final l = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.usageLimitTitle(featureName)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.usageLimitMessage(dailyLimit)),
            const SizedBox(height: 8),
            Text(
              l.usageLimitUpgrade,
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.ok),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PaywallScreen(),
                ),
              );
            },
            child: Text(l.upgrade),
          ),
        ],
      ),
    );
  }
}
