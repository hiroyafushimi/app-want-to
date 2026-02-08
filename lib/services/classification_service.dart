/// 分類ロジック（仕様 4: 無料=ルールベース、有料=ML Kit 追加）
/// 商品 / 文章 / その他
enum ClassificationType {
  product,
  text,
  other,
}

/// ルールベース分類（MVP: 商品キーワード等）
class ClassificationService {
  static const productKeywords = [
    '¥', '円', '税込', '送料', 'Amazon', '楽天', 'Yahoo!ショッピング',
    '価格', 'セール', '在庫', '購入', 'カート',
  ];

  static ClassificationType classify(String text) {
    if (text.trim().isEmpty) return ClassificationType.other;
    final t = text.trim();
    for (final k in productKeywords) {
      if (t.contains(k)) return ClassificationType.product;
    }
    // TODO: 正規表現 \d+円, ¥\d+, amazon.co.jp, rakuten.co.jp
    return ClassificationType.text;
  }
}
