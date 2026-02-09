import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/classification_service.dart';

/// 結果画面（仕様 6. 画面フロー 3）
///
/// - OCR テキスト表示（コピー可能）
/// - 自動分類結果 + フォールバック選択 UI
/// - アクションボタン（商品/文章/その他で切替）
class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.ocrText,
    required this.classification,
    this.croppedImageBytes,
  });

  /// OCR 認識テキスト
  final String ocrText;

  /// 自動分類結果
  final ClassificationType classification;

  /// 切り出し画像（プレビュー用）
  final Uint8List? croppedImageBytes;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ClassificationType _selectedType;
  final TextEditingController _subLabelController = TextEditingController();
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.classification;
  }

  @override
  void dispose() {
    _subLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR 結果'),
        actions: [
          // 切り出し画像プレビュー切替
          if (widget.croppedImageBytes != null)
            IconButton(
              icon: Icon(_showImage ? Icons.text_fields : Icons.image),
              tooltip: _showImage ? 'テキスト表示' : '画像プレビュー',
              onPressed: () => setState(() => _showImage = !_showImage),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ───── OCR テキスト or 画像プレビュー ─────
            Expanded(
              child: _showImage && widget.croppedImageBytes != null
                  ? _buildImagePreview()
                  : _buildTextDisplay(theme),
            ),
            // ───── 分類セクション ─────
            _buildClassificationSection(theme),
            // ───── アクションボタン ─────
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  // ───── テキスト表示 ─────

  Widget _buildTextDisplay(ThemeData theme) {
    if (widget.ocrText.trim().isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.text_snippet_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('テキストを認識できませんでした', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return GestureDetector(
      onLongPress: () => _copyText(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // コピーヒント
            Row(
              children: [
                Icon(Icons.content_copy, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  '長押しでコピー',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // OCR テキスト
            SelectableText(
              widget.ocrText,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  // ───── 画像プレビュー ─────

  Widget _buildImagePreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          widget.croppedImageBytes!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ───── 分類セクション ─────

  Widget _buildClassificationSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトル
          Text(
            'このテキストはどの内容ですか？',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          // セグメントボタン（商品/文章/その他）
          SegmentedButton<ClassificationType>(
            segments: ClassificationType.values
                .map((t) => ButtonSegment<ClassificationType>(
                      value: t,
                      label: Text(t.label),
                    ))
                .toList(),
            selected: {_selectedType},
            onSelectionChanged: (s) => setState(() => _selectedType = s.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: 8),
          // 小項目フリー入力（100文字まで）
          TextField(
            controller: _subLabelController,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: _subLabelHint,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: const OutlineInputBorder(),
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }

  String get _subLabelHint {
    switch (_selectedType) {
      case ClassificationType.product:
        return '例: 楽天セールページ';
      case ClassificationType.text:
        return '例: ブログ引用、質問文';
      case ClassificationType.other:
        return '例: Slack メッセージ';
    }
  }

  // ───── アクションボタン ─────

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
      ),
      child: Column(
        children: [
          // メインアクション（分類に応じて変わる）
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed:
                  widget.ocrText.trim().isEmpty ? null : _onMainAction,
              icon: Icon(_mainActionIcon),
              label: Text(_mainActionLabel),
            ),
          ),
          const SizedBox(height: 8),
          // 共通アクション行
          Row(
            children: [
              // コピー
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.ocrText.trim().isEmpty
                      ? null
                      : () => _copyText(context),
                  icon: const Icon(Icons.content_copy, size: 18),
                  label: const Text('コピー'),
                ),
              ),
              const SizedBox(width: 8),
              // OS 共有
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.ocrText.trim().isEmpty
                      ? null
                      : () => _shareText(context),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('共有'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData get _mainActionIcon {
    switch (_selectedType) {
      case ClassificationType.product:
        return Icons.shopping_cart;
      case ClassificationType.text:
        return Icons.smart_toy;
      case ClassificationType.other:
        return Icons.content_copy;
    }
  }

  String get _mainActionLabel {
    switch (_selectedType) {
      case ClassificationType.product:
        return '通販サイトで検索';
      case ClassificationType.text:
        return 'AI に聞く';
      case ClassificationType.other:
        return 'テキストをコピー';
    }
  }

  // ───── アクション実行 ─────

  void _onMainAction() {
    switch (_selectedType) {
      case ClassificationType.product:
        _openProductSearch(context);
        break;
      case ClassificationType.text:
        _openAiModal(context);
        break;
      case ClassificationType.other:
        _copyText(context);
        break;
    }
  }

  /// 商品: 通販サイト検索 URL 生成 → 選択して開く
  void _openProductSearch(BuildContext context) {
    final query = ClassificationService.extractProductQuery(widget.ocrText);
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('検索クエリを生成できませんでした')),
      );
      return;
    }
    final encoded = Uri.encodeComponent(query);
    final sites = [
      _SearchSite('Amazon', 'https://www.amazon.co.jp/s?k=$encoded'),
      _SearchSite('楽天', 'https://search.rakuten.co.jp/search/mall/$encoded/'),
      _SearchSite(
          'Yahoo!ショッピング', 'https://shopping.yahoo.co.jp/search?p=$encoded'),
    ];

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '「$query」を検索',
                style: Theme.of(ctx).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...sites.map((s) => ListTile(
                  leading: const Icon(Icons.open_in_browser),
                  title: Text(s.name),
                  subtitle: Text(s.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    Navigator.pop(ctx);
                    _launchUrl(s.url);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// 文章: AI モーダル（仕様 5. AI連携プロンプト設計）
  void _openAiModal(BuildContext context) {
    // TODO: AI 送信機能（API Key 設定後に実装）
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI に聞く', style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '⚠️ API Key が未設定です',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '設定画面で OpenAI / Claude などの API Key を登録すると、'
                        'AI による要約・質問回答・翻訳などが利用できます。',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).pushNamed('/settings');
                    },
                    child: const Text('設定画面を開く'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// コピー
  void _copyText(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.ocrText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('コピーしました'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// OS 共有
  void _shareText(BuildContext context) {
    SharePlus.instance.share(ShareParams(text: widget.ocrText));
  }

  /// URL を開く
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SearchSite {
  const _SearchSite(this.name, this.url);
  final String name;
  final String url;
}
