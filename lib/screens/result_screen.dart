import 'package:flutter/material.dart';

/// 結果画面：テキスト表示・分類・フォールバックUI・アクションボタン（仕様 6. 画面フロー 3）
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('OCR結果・分類・アクション（実装予定）')),
    );
  }
}
