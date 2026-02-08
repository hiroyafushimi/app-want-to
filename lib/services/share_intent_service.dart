import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// 共有シートから受け取ったメディア（画像）をストリームで通知。
/// アプリ起動時（getInitialMedia）と起動中（getMediaStream）の両方に対応。
/// iOS/Android 以外（macOS/Web）ではプラグイン未実装のため空で返す。
class ShareIntentService {
  ShareIntentService() {
    _initial = _getInitialMediaSafe();
    _stream = _getMediaStreamSafe();
  }

  late final Future<List<SharedMediaFile>> _initial;
  late final Stream<List<SharedMediaFile>> _stream;

  /// アプリが閉じている間に共有されたメディア（起動時に1回）
  Future<List<SharedMediaFile>> get initialMedia => _initial;

  /// アプリ起動中に共有されたメディアのストリーム
  Stream<List<SharedMediaFile>> get mediaStream => _stream;

  /// 初回取得後にリセット（再度 getInitialMedia が返るように）
  static Future<void> reset() async {
    if (!_isSupportedPlatform) return;
    try {
      await ReceiveSharingIntent.instance.reset();
    } catch (_) {
      // 未対応プラットフォームでは無視
    }
  }

  static bool get _isSupportedPlatform =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  Future<List<SharedMediaFile>> _getInitialMediaSafe() async {
    if (!_isSupportedPlatform) return [];
    try {
      return await ReceiveSharingIntent.instance.getInitialMedia();
    } catch (_) {
      return [];
    }
  }

  Stream<List<SharedMediaFile>> _getMediaStreamSafe() {
    if (!_isSupportedPlatform) return Stream.empty();
    try {
      return ReceiveSharingIntent.instance.getMediaStream();
    } catch (_) {
      return Stream.empty();
    }
  }
}
