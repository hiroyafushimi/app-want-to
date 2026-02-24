/// 検索サイト定義
class SearchSite {
  const SearchSite({required this.name, required this.urlTemplate});

  final String name;

  /// URL テンプレート。`{query}` が URI エンコード済みクエリで置換される。
  final String urlTemplate;

  /// エンコード済みクエリを埋め込んだ URL を生成する。
  String buildUrl(String rawQuery) {
    final encoded = Uri.encodeComponent(rawQuery);
    return urlTemplate.replaceAll('{query}', encoded);
  }
}

/// アプリ全体で使用する定数
class AppConstants {
  AppConstants._();

  /// 選択矩形の最小サイズ（ピクセル）
  static const double kMinSelectionSize = 10.0;

  /// RepaintBoundary キャプチャ時の pixelRatio
  static const double kCapturePixelRatio = 2.0;

  /// 文章分類の最小文字数
  static const int kMinTextClassificationLength = 20;

  /// 商品クエリの最大文字数
  static const int kMaxProductQueryLength = 60;

  /// 商品検索サイト一覧
  static const List<SearchSite> searchSites = [
    SearchSite(
      name: 'Amazon',
      urlTemplate: 'https://www.amazon.co.jp/s?k={query}',
    ),
    SearchSite(
      name: 'Rakuten',
      urlTemplate: 'https://search.rakuten.co.jp/search/mall/{query}/',
    ),
    SearchSite(
      name: 'Yahoo! Shopping',
      urlTemplate: 'https://shopping.yahoo.co.jp/search?p={query}',
    ),
  ];
}
