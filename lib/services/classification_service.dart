/// 分類ロジック（仕様 4: 無料=ルールベース、有料=ML Kit 追加）
/// 商品 / 文章 / その他
enum ClassificationType {
  product,
  text,
  other;

  /// UI 表示用ラベル
  String get label {
    switch (this) {
      case ClassificationType.product:
        return '商品';
      case ClassificationType.text:
        return '文章';
      case ClassificationType.other:
        return 'その他';
    }
  }

  /// アイコン
  String get emoji {
    switch (this) {
      case ClassificationType.product:
        return '🛒';
      case ClassificationType.text:
        return '📝';
      case ClassificationType.other:
        return '📋';
    }
  }
}

/// ルールベース分類（MVP: 商品キーワード + 正規表現）
class ClassificationService {
  // ── 商品判定キーワード ──
  static const _productKeywords = [
    '¥',
    '円',
    '税込',
    '税抜',
    '送料',
    'Amazon',
    'amazon',
    '楽天',
    'Rakuten',
    'rakuten',
    'Yahoo!ショッピング',
    'Yahoo!',
    '価格',
    'セール',
    '在庫',
    '購入',
    'カート',
    'ポイント',
    '割引',
    'OFF',
    'クーポン',
    'お買い得',
    'タイムセール',
  ];

  // ── 商品判定の正規表現パターン ──
  static final _productPatterns = [
    RegExp(r'\d+円'),           // 1000円
    RegExp(r'\d+,\d+円'),      // 1,000円
    RegExp(r'¥\d+'),           // ¥1000
    RegExp(r'¥[\d,]+'),        // ¥1,000
    RegExp(r'amazon\.co\.jp', caseSensitive: false),
    RegExp(r'rakuten\.co\.jp', caseSensitive: false),
    RegExp(r'yahoo\.co\.jp', caseSensitive: false),
    RegExp(r'shopping\.yahoo', caseSensitive: false),
    RegExp(r'\d+%\s*OFF', caseSensitive: false),
  ];

  /// テキストを分類する。
  ///
  /// 1. 商品キーワード/正規表現にマッチ → [ClassificationType.product]
  /// 2. ある程度の長さがある → [ClassificationType.text]
  /// 3. どちらにも該当しない短文 → [ClassificationType.other]
  static ClassificationType classify(String text) {
    if (text.trim().isEmpty) return ClassificationType.other;
    final t = text.trim();

    // ── 商品判定 ──
    for (final k in _productKeywords) {
      if (t.contains(k)) return ClassificationType.product;
    }
    for (final p in _productPatterns) {
      if (p.hasMatch(t)) return ClassificationType.product;
    }

    // ── 文章判定（20文字以上なら文章とみなす） ──
    if (t.length >= 20) return ClassificationType.text;

    // ── その他 ──
    return ClassificationType.other;
  }

  /// 商品テキストから検索クエリを生成する。
  /// 価格・記号・URL を除去し、商品名らしい部分だけ抽出する。
  static String extractProductQuery(String text) {
    var q = text;
    // URL を除去
    q = q.replaceAll(RegExp(r'https?://\S+'), '');
    // 価格表記を除去
    q = q.replaceAll(RegExp(r'[¥￥]\s*[\d,]+'), '');
    q = q.replaceAll(RegExp(r'[\d,]+円'), '');
    q = q.replaceAll(RegExp(r'\d+%\s*OFF', caseSensitive: false), '');
    // 記号・改行を空白に
    q = q.replaceAll(RegExp(r'[【】「」『』\[\]()（）\n\r\t]+'), ' ');
    // 連続空白を1つに
    q = q.replaceAll(RegExp(r'\s+'), ' ').trim();
    // 長すぎる場合は先頭 60 文字
    if (q.length > 60) q = q.substring(0, 60);
    return q;
  }
}
