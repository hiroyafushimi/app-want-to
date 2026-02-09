import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// OCR サービス（仕様 3: iOS=Apple Vision / Android=Google ML Kit）
///
/// google_mlkit_text_recognition は iOS では Apple Vision、
/// Android では Google ML Kit を内部で使い分ける。
/// 日本語テキスト（縦書き含む）に対応。
class OcrService {
  OcrService()
      : _recognizer = TextRecognizer(script: TextRecognitionScript.japanese);

  final TextRecognizer _recognizer;

  /// ファイルパスから OCR を実行し、認識テキストを返す。
  Future<OcrResult> recognizeFromFile(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    return _recognize(inputImage);
  }

  /// メモリ上の画像バイト列（PNG/JPEG）から OCR を実行する。
  ///
  /// 一旦テンポラリファイルに書き出してから処理する。
  Future<OcrResult> recognizeFromBytes(Uint8List bytes) async {
    final tempDir = Directory.systemTemp.path;
    final tempFile = File(
      '$tempDir/wan_to_ocr_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await tempFile.writeAsBytes(bytes);
    try {
      return await recognizeFromFile(tempFile.path);
    } finally {
      try {
        await tempFile.delete();
      } catch (_) {}
    }
  }

  Future<OcrResult> _recognize(InputImage inputImage) async {
    try {
      final recognized = await _recognizer.processImage(inputImage);
      final blocks = <OcrBlock>[];

      for (final block in recognized.blocks) {
        final lines = <OcrLine>[];
        for (final line in block.lines) {
          lines.add(OcrLine(
            text: line.text,
            boundingBox: line.boundingBox,
          ));
        }
        blocks.add(OcrBlock(
          text: block.text,
          lines: lines,
          boundingBox: block.boundingBox,
        ));
      }

      final fullText = recognized.text;
      debugPrint(
          '[OCR] 認識完了: ${fullText.length} 文字, ${blocks.length} ブロック');
      return OcrResult(text: fullText, blocks: blocks);
    } catch (e) {
      debugPrint('[OCR] エラー: $e');
      rethrow;
    }
  }

  /// リソース解放
  Future<void> dispose() async {
    await _recognizer.close();
  }
}

/// OCR 結果
class OcrResult {
  const OcrResult({required this.text, required this.blocks});

  /// 全ブロックを結合したテキスト
  final String text;

  /// 認識ブロック一覧
  final List<OcrBlock> blocks;

  bool get isEmpty => text.trim().isEmpty;
}

/// OCR ブロック（段落相当）
class OcrBlock {
  const OcrBlock({
    required this.text,
    required this.lines,
    this.confidence,
    this.boundingBox,
  });

  final String text;
  final double? confidence;
  final List<OcrLine> lines;
  final Rect? boundingBox;
}

/// OCR 行
class OcrLine {
  const OcrLine({
    required this.text,
    this.confidence,
    this.boundingBox,
  });

  final String text;
  final double? confidence;
  final Rect? boundingBox;
}
