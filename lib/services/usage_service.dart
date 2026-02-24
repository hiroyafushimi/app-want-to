import 'package:flutter/foundation.dart';

import '../utils/app_logger.dart';

/// 日次使用回数管理サービス（仕様 1.4: 無料=OCR 5回/日, AI 1回/日）
///
/// SharedPreferences ではなくメモリ+日付チェックで軽量実装。
/// アプリ再起動でリセットされるが、MVP では許容。
/// 本番では SharedPreferences or ローカル DB に永続化する。
class UsageService {
  UsageService._() : _clock = DateTime.now;
  static final UsageService instance = UsageService._();

  /// テスト用コンストラクタ（clock injection）
  @visibleForTesting
  UsageService.forTest({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  static const _log = AppLogger('Usage');

  // ── 無料プラン上限 ──
  static const int freeOcrLimit = 5;
  static const int freeAiLimit = 1;

  // ── 内部カウンター ──
  final _UsageCounter _ocr = _UsageCounter(limit: freeOcrLimit, label: 'OCR');
  final _UsageCounter _ai = _UsageCounter(limit: freeAiLimit, label: 'AI');
  String _dateKey = '';

  /// 有料プラン所持フラグ（IAPService と連携して更新）
  bool isPremium = false;

  final DateTime Function() _clock;

  /// 今日の日付キー
  String get _today {
    final now = _clock();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// 日付が変わったらカウンターをリセット
  void _resetIfNewDay() {
    final today = _today;
    if (_dateKey != today) {
      _ocr.reset();
      _ai.reset();
      _dateKey = today;
      _log.info('日付リセット: $today');
    }
  }

  // ── OCR ──

  /// OCR の残り回数
  int get remainingOcr {
    if (isPremium) return -1; // 無制限
    _resetIfNewDay();
    return _ocr.remaining;
  }

  /// OCR が実行可能か
  bool get canUseOcr {
    if (isPremium) return true;
    _resetIfNewDay();
    return _ocr.canUse;
  }

  /// OCR 使用をカウント。成功時 true、上限到達で false。
  bool consumeOcr() {
    if (isPremium) return true;
    _resetIfNewDay();
    final ok = _ocr.consume();
    if (ok) _log.info('OCR 使用: ${_ocr.count}/$freeOcrLimit');
    return ok;
  }

  // ── AI ──

  /// AI の残り回数
  int get remainingAi {
    if (isPremium) return -1; // 無制限
    _resetIfNewDay();
    return _ai.remaining;
  }

  /// AI が実行可能か
  bool get canUseAi {
    if (isPremium) return true;
    _resetIfNewDay();
    return _ai.canUse;
  }

  /// AI 使用をカウント。成功時 true、上限到達で false。
  bool consumeAi() {
    if (isPremium) return true;
    _resetIfNewDay();
    final ok = _ai.consume();
    if (ok) _log.info('AI 使用: ${_ai.count}/$freeAiLimit');
    return ok;
  }
}

/// 単一リソースの日次カウンター。
class _UsageCounter {
  _UsageCounter({required this.limit, required this.label});

  final int limit;
  final String label;
  int _count = 0;

  int get count => _count;
  int get remaining => (limit - _count).clamp(0, limit);
  bool get canUse => _count < limit;

  bool consume() {
    if (_count >= limit) return false;
    _count++;
    return true;
  }

  void reset() => _count = 0;
}
