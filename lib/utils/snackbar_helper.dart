import 'package:flutter/material.dart';

/// SnackBar 表示を簡潔にする [BuildContext] 拡張。
extension SnackBarHelper on BuildContext {
  /// テキストメッセージの SnackBar を表示する。
  void showSnackBarMessage(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }
}
