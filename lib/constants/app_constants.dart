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
}
