/// OCR 結果（仕様: 画像制限 5MB / 4096x4096、JPEG/PNG/HEIC）
class OcrResult {
  const OcrResult({required this.text, this.rawBytesLength});

  final String text;
  final int? rawBytesLength;
}
