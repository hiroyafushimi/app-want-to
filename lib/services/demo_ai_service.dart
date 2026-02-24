import '../utils/app_logger.dart';
import 'ai_service.dart';

/// デモ AI サービス（API Key 未設定時のお試し機能）
///
/// 実際の API 通信は行わず、プロンプト種別に応じた
/// 定型のデモ応答を返す。データ送信が発生しないため
/// AiConsentDialog は不要。
class DemoAiService {
  static const _log = AppLogger('DemoAI');

  /// デモ応答を生成する。
  ///
  /// [ocrText] と [userInput] は無視され、定型テキストを返す。
  /// 実際の API 呼び出しを模擬するため短い遅延を含む。
  Future<AiResult> process({
    required String ocrText,
    required AiPromptType promptType,
    String? userInput,
  }) async {
    _log.info('デモ応答生成: ${promptType.name}');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return AiResult(success: true, text: _demoResponse(promptType), isDemo: true);
  }

  String _demoResponse(AiPromptType type) {
    switch (type) {
      case AiPromptType.summary:
        return 'これはデモの要約結果です。実際の API Key を設定すると、'
            'AI がテキストを分析して簡潔な要約を生成します。\n\n'
            'This is a demo summary. Set a real API key to get '
            'AI-generated summaries of your text.';
      case AiPromptType.question:
        return 'これはデモの質問回答です。実際の API Key を設定すると、'
            'AI がテキストの内容に基づいて質問に回答します。\n\n'
            'This is a demo answer. Set a real API key to get '
            'AI-powered answers about your text.';
      case AiPromptType.translate:
        return 'This is a demo translation. With a real API key, '
            'the AI would translate your Japanese text into natural English.\n\n'
            'これはデモの翻訳結果です。実際の API Key を設定すると、'
            'AI が自然な英語に翻訳します。';
      case AiPromptType.custom:
        return 'これはデモのカスタム応答です。実際の API Key を設定すると、'
            'AI が指示に従ってテキストを処理します。\n\n'
            'This is a demo custom response. Set a real API key to get '
            'AI responses tailored to your instructions.';
    }
  }
}
