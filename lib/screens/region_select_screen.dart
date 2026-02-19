import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../services/classification_service.dart';
import '../services/ocr_service.dart';
import '../services/usage_service.dart';
import '../utils/safe_set_state.dart';
import '../utils/usage_limit_dialog.dart';
import 'result_screen.dart';

/// 範囲指定画面 → 指で囲む → OCR実行（仕様 6. 画面フロー 2）
///
/// 画像を表示し、ユーザーが指でドラッグして矩形領域を選択する。
/// 「OCR 実行」ボタンで選択範囲の画像を切り出し、結果画面へ遷移する。
class RegionSelectScreen extends StatefulWidget {
  const RegionSelectScreen({super.key, this.imagePath});

  /// 受信画像のローカルパス
  final String? imagePath;

  @override
  State<RegionSelectScreen> createState() => _RegionSelectScreenState();
}

class _RegionSelectScreenState extends State<RegionSelectScreen>
    with SafeSetState {
  /// 画像キー（切り出し用）
  final GlobalKey _imageKey = GlobalKey();

  /// ドラッグ領域キー（座標変換用）
  final GlobalKey _gestureKey = GlobalKey();

  /// ドラッグ開始点（画像ウィジェット座標系）
  Offset? _start;

  /// ドラッグ終了点（画像ウィジェット座標系）
  Offset? _end;

  /// 切り出し中フラグ
  bool _cropping = false;

  /// 矩形が有効か（面積が最低限ある）
  bool get _hasSelection {
    if (_start == null || _end == null) return false;
    final r = _selectionRect;
    return r.width > AppConstants.kMinSelectionSize &&
        r.height > AppConstants.kMinSelectionSize;
  }

  /// 正規化された選択矩形（左上→右下）
  Rect get _selectionRect {
    final s = _start!;
    final e = _end!;
    return Rect.fromPoints(s, e);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (widget.imagePath == null || !File(widget.imagePath!).existsSync()) {
      return Scaffold(
        appBar: AppBar(title: Text(l.regionSelect)),
        body: Center(child: Text(l.noImageSpecified)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.regionSelect),
        actions: [
          // リセット
          if (_hasSelection)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l.resetTooltip,
              onPressed: () => setState(() {
                _start = null;
                _end = null;
              }),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l.settingsTooltip,
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ───── 説明テキスト ─────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l.regionSelectInstruction,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            // ───── 画像 + 選択矩形 ─────
            Expanded(
              child: GestureDetector(
                key: _gestureKey,
                behavior: HitTestBehavior.opaque,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: RepaintBoundary(
                      key: _imageKey,
                      child: Stack(
                        children: [
                          // 画像
                          Image.file(
                            File(widget.imagePath!),
                            fit: BoxFit.contain,
                          ),
                          // 選択矩形オーバーレイ
                          if (_start != null && _end != null)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _SelectionOverlayPainter(
                                  rect: _selectionRect,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ───── OCR 実行ボタン ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _hasSelection && !_cropping ? _onOcrTap : null,
                  icon: _cropping
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.text_fields),
                  label: Text(_cropping ? l.processing : l.ocrExecute),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───── ドラッグ ─────

  /// GestureDetector のローカル座標を画像ウィジェット座標に変換・クランプ
  Offset _toImageLocal(Offset gestureLocal) {
    final imageBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    final gestureBox =
        _gestureKey.currentContext?.findRenderObject() as RenderBox?;
    if (imageBox == null || gestureBox == null) return gestureLocal;

    // GestureDetector ローカル → グローバル → 画像ウィジェットローカル
    final globalPos = gestureBox.localToGlobal(gestureLocal);
    final imageLocal = imageBox.globalToLocal(globalPos);

    // 画像領域にクランプ（0 〜 画像ウィジェットサイズ）
    final size = imageBox.size;
    return Offset(
      imageLocal.dx.clamp(0, size.width),
      imageLocal.dy.clamp(0, size.height),
    );
  }

  void _onPanStart(DragStartDetails d) {
    final local = _toImageLocal(d.localPosition);
    setState(() {
      _start = local;
      _end = local;
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _end = _toImageLocal(d.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails d) {
    // 矩形が小さすぎる場合はリセット
    if (!_hasSelection) {
      setState(() {
        _start = null;
        _end = null;
      });
    }
  }

  // ───── OCR 実行（切り出し → OCR → 結果画面へ） ─────

  Future<void> _onOcrTap() async {
    if (!_hasSelection) return;
    if (!_checkUsageLimit()) return;

    setState(() => _cropping = true);
    try {
      await _performOcrAndNavigate();
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.ocrFailed(e.toString()))),
      );
    } finally {
      safeSetState(() => _cropping = false);
    }
  }

  /// 無料回数チェック。使用可能なら true、上限到達ならダイアログ表示して false。
  bool _checkUsageLimit() {
    if (UsageService.instance.canUseOcr) return true;
    if (!mounted) return false;
    showUsageLimitDialog(
      context,
      featureName: 'OCR',
      dailyLimit: UsageService.freeOcrLimit,
    );
    return false;
  }

  /// OCR 実行 → 分類 → 結果画面遷移
  Future<void> _performOcrAndNavigate() async {
    final croppedBytes = await _captureSelectedRegion();
    if (!mounted) return;

    final ocrService = OcrService();
    try {
      final result = await ocrService.recognizeFromBytes(
        Uint8List.fromList(croppedBytes),
      );
      if (!mounted) return;

      UsageService.instance.consumeOcr();
      final classification = ClassificationService.classify(result.text);

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResultScreen(
            ocrText: result.text,
            classification: classification,
            croppedImageBytes: Uint8List.fromList(croppedBytes),
          ),
        ),
      );
    } finally {
      await ocrService.dispose();
    }
  }

  /// RepaintBoundary をキャプチャし、選択範囲だけを切り出す
  Future<List<int>> _captureSelectedRegion() async {
    final renderObject = _imageKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) {
      throw StateError('Image widget not found for capture');
    }
    final boundary = renderObject;
    final fullImage =
        await boundary.toImage(pixelRatio: AppConstants.kCapturePixelRatio);

    // ウィジェット座標 → キャプチャ画像座標（pixelRatio 分スケール）
    final scaleX = fullImage.width / boundary.size.width;
    final scaleY = fullImage.height / boundary.size.height;
    final sr = _selectionRect;
    final cropRect = Rect.fromLTRB(
      (sr.left * scaleX).clamp(0, fullImage.width.toDouble()),
      (sr.top * scaleY).clamp(0, fullImage.height.toDouble()),
      (sr.right * scaleX).clamp(0, fullImage.width.toDouble()),
      (sr.bottom * scaleY).clamp(0, fullImage.height.toDouble()),
    );

    // 切り出し
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      fullImage,
      cropRect,
      Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
      Paint(),
    );
    final picture = recorder.endRecording();
    final cropped = await picture.toImage(
      cropRect.width.round(),
      cropRect.height.round(),
    );

    final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('Failed to encode cropped image to PNG');
    }
    return byteData.buffer.asUint8List();
  }
}

/// ───── 選択矩形のオーバーレイペインター ─────
class _SelectionOverlayPainter extends CustomPainter {
  _SelectionOverlayPainter({required this.rect});

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    // 選択範囲外を半透明で暗くする
    final dimPaint = Paint()..color = Colors.black.withValues(alpha: 0.4);
    // 上
    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, rect.top), dimPaint);
    // 下
    canvas.drawRect(
        Rect.fromLTRB(0, rect.bottom, size.width, size.height), dimPaint);
    // 左
    canvas.drawRect(
        Rect.fromLTRB(0, rect.top, rect.left, rect.bottom), dimPaint);
    // 右
    canvas.drawRect(
        Rect.fromLTRB(rect.right, rect.top, size.width, rect.bottom),
        dimPaint);

    // 選択枠の白い線
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, borderPaint);

    // 四隅のハンドル
    final handlePaint = Paint()..color = Colors.white;
    const handleSize = 8.0;
    for (final p in [
      rect.topLeft,
      rect.topRight,
      rect.bottomLeft,
      rect.bottomRight,
    ]) {
      canvas.drawCircle(p, handleSize / 2, handlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SelectionOverlayPainter old) =>
      old.rect != rect;
}

