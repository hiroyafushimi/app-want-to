import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 共有シート経由起動 → 受信画像表示（仕様 6. 画面フロー 1）
class ReceivedImageScreen extends StatelessWidget {
  const ReceivedImageScreen({
    super.key,
    this.imagePath,
    this.imageBytes,
  });

  /// 共有された画像のローカルパス（receive_sharing_intent から）
  final String? imagePath;

  /// 画像バイト（パスがない場合の代替）
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (imagePath != null && File(imagePath!).existsSync()) {
      imageWidget = Image.file(
        File(imagePath!),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    } else if (imageBytes != null && imageBytes!.isNotEmpty) {
      imageWidget = Image.memory(
        imageBytes!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    } else {
      imageWidget = _placeholder(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('受信画像'),
        actions: [
          if (imagePath != null || (imageBytes != null && imageBytes!.isNotEmpty))
            TextButton(
              onPressed: () => _onNext(context),
              child: const Text('範囲指定へ'),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: imageWidget,
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return const Center(
      child: Text('画像がありません。共有シートから画像を送ってください。'),
    );
  }

  void _onNext(BuildContext context) {
    final path = imagePath;
    if (path == null) return;
    Navigator.of(context).pushNamed(
      '/region_select',
      arguments: path,
    );
  }
}
