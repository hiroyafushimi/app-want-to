import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_key_storage.dart';
import '../services/share_debug_log_service.dart';

/// 設定画面：API Key入力、残り回数、課金（仕様 6. 画面フロー 5）
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ApiKeyStorage _storage = ApiKeyStorage();
  bool _hasKey = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadKeyStatus();
  }

  Future<void> _loadKeyStatus() async {
    final key = await _storage.read();
    if (mounted) {
      setState(() {
        _hasKey = key != null && key.isNotEmpty;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          // ───── API Key セクション ─────
          _buildSectionHeader('AI 連携'),
          ListTile(
            leading: Icon(
              _hasKey ? Icons.vpn_key : Icons.vpn_key_off,
              color: _hasKey ? Colors.green : Colors.grey,
            ),
            title: const Text('OpenAI API Key'),
            subtitle: Text(
              _loading
                  ? '読み込み中...'
                  : _hasKey
                      ? '設定済み（${ApiKeyStorage.mask("key")}）'
                      : '未設定',
            ),
            trailing: _hasKey
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: '削除',
                    onPressed: _confirmDeleteKey,
                  )
                : null,
            onTap: () => _showApiKeyInput(context),
          ),
          if (!_hasKey)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'OpenAI の API Key を設定すると、OCR テキストの要約・質問回答・翻訳などが利用できます。\n'
                  'API Key は端末内に暗号化保存され、OpenAI 以外には送信されません。',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
          const Divider(height: 32),

          // ───── デバッグセクション ─────
          _buildSectionHeader('デバッグ'),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // ───── API Key 入力ダイアログ ─────

  void _showApiKeyInput(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('OpenAI API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'sk-... で始まるキーを入力してください。',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'sk-...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              final key = controller.text.trim();
              if (key.isEmpty) return;
              await _storage.save(key);
              if (ctx.mounted) Navigator.pop(ctx);
              _loadKeyStatus();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API Key を保存しました')),
                );
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  // ───── API Key 削除確認 ─────

  void _confirmDeleteKey() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('API Key を削除'),
        content: const Text('保存されている API Key を削除しますか？\nAI 機能が使えなくなります。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _storage.delete();
              if (ctx.mounted) Navigator.pop(ctx);
              _loadKeyStatus();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API Key を削除しました')),
                );
              }
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}

// ───── 共有デバッグログ画面（既存） ─────

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
            icon: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
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
