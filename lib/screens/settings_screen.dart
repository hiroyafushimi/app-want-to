import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/share_debug_log_service.dart';

/// 設定画面：API Key入力、残り回数、課金（仕様 6. 画面フロー 5）
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('API Key・回数・課金'),
            subtitle: Text('実装予定'),
          ),
          const Divider(),
          ListTile(
            title: const Text('共有デバッグログ（iOS）'),
            subtitle: const Text('Share Extension のログを確認'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const _ShareDebugLogScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareDebugLogScreen extends StatefulWidget {
  const _ShareDebugLogScreen();

  @override
  State<_ShareDebugLogScreen> createState() => _ShareDebugLogScreenState();
}

class _ShareDebugLogScreenState extends State<_ShareDebugLogScreen> {
  String _log = '読み込み中...';
  bool _loading = false;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _log = '読み込み中...';
    });
    final log = await ShareDebugLogService.getShareExtensionDebugLog();
    if (mounted) {
      setState(() {
        _log = log.isEmpty ? '(空)' : log;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('共有デバッグログ'),
        actions: [
          IconButton(
            icon: _loading ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ) : const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _log));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('コピーしました')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          _log,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ),
    );
  }
}
