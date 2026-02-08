import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// 共有シートから受け取ったメディア（画像）をストリームで通知。
/// アプリ起動時（getInitialMedia）と起動中（getMediaStream）の両方に対応。
class ShareIntentService {
  ShareIntentService() {
    _initial = ReceiveSharingIntent.getInitialMedia();
    _stream = ReceiveSharingIntent.getMediaStream();
  }

  late final Future<List<SharedMediaFile>> _initial;
  late final Stream<List<SharedMediaFile>> _stream;

  /// アプリが閉じている間に共有されたメディア（起動時に1回）
  Future<List<SharedMediaFile>> get initialMedia => _initial;

  /// アプリ起動中に共有されたメディアのストリーム
  Stream<List<SharedMediaFile>> get mediaStream => _stream;

  /// 初回取得後にリセット（再度 getInitialMedia が返るように）
  static Future<void> reset() => ReceiveSharingIntent.reset();
}
