import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context)!;

    Widget imageWidget;
    if (imagePath != null && File(imagePath!).existsSync()) {
      imageWidget = Image.file(
        File(imagePath!),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(l),
      );
    } else if (imageBytes != null && imageBytes!.isNotEmpty) {
      imageWidget = Image.memory(
        imageBytes!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(l),
      );
    } else {
      imageWidget = _placeholder(l);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.receivedImage),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l.settingsTooltip,
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
          if (imagePath != null || (imageBytes != null && imageBytes!.isNotEmpty))
            TextButton(
              onPressed: () => _onNext(context),
              child: Text(l.goToRegionSelect),
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

  Widget _placeholder(AppLocalizations l) {
    return Center(
      child: Text(l.noImage),
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
