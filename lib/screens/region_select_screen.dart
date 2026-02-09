import 'package:flutter/material.dart';

/// 範囲指定画面 → 囲み → OCR実行（仕様 6. 画面フロー 2）
class RegionSelectScreen extends StatelessWidget {
  const RegionSelectScreen({super.key, this.imagePath});

  /// 受信画像のローカルパス（ReceivedImageScreen から渡す）
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('範囲指定')),
      body: Center(
        child: imagePath != null
            ? Text('画像: $imagePath\n範囲選択・OCR（実装予定）')
            : const Text('画像が指定されていません。'),
      ),
    );
  }
}
