import 'package:flutter/material.dart';

/// `if (mounted) setState(...)` パターンを簡潔にするミックスイン。
///
/// 非同期処理完了後の setState で State が既に破棄されている場合を安全にスキップする。
mixin SafeSetState<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }
}
