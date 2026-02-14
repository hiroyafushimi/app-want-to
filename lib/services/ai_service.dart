import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// AI プロンプト種別（仕様 5. AI連携プロンプト設計）
enum AiPromptType {
  summary,
  question,
  translate,
  custom;

  String get label {
    switch (this) {
      case AiPromptType.summary:
        return '要約';
      case AiPromptType.question:
        return '質問回答';
      case AiPromptType.translate:
        return '翻訳（日→英）';
      case AiPromptType.custom:
        return 'カスタム';
    }
  }

  String get description {
    switch (this) {
      case AiPromptType.summary:
        return '300字以内で簡潔に要約';
      case AiPromptType.question:
        return 'テキストについて質問に回答';
      case AiPromptType.translate:
        return '自然な英語に翻訳';
      case AiPromptType.custom:
        return '自由にプロンプトを入力';
    }
  }

  /// システムプロンプトを生成する。
  /// [userInput] はフリー入力テキスト（質問/カスタム用）。
  String buildSystemPrompt(String? userInput) {
    switch (this) {
      case AiPromptType.summary:
        return '以下のテキストを300字以内で簡潔に要約してください。';
      case AiPromptType.question:
        final q = (userInput ?? '').trim();
        return '以下のテキストを読んで、ユーザーの質問に答えてください。質問：$q';
      case AiPromptType.translate:
        return '以下のテキストを自然な英語に翻訳してください。';
      case AiPromptType.custom:
        final instruction = (userInput ?? '').trim();
        return '以下のテキストに対して、次の指示を実行してください。\n指示：$instruction';
    }
  }

  /// フリー入力が必要かどうか
  bool get needsUserInput =>
      this == AiPromptType.question || this == AiPromptType.custom;
}

/// AI サービス（仕様 5: ユーザー API Key で外部 LLM 呼び出し）
///
/// OpenAI Chat Completions API 互換エンドポイントを使用。
/// API Key はログ出力・ネットワーク送信先（本サービス以外）に含めない。
class AiService {
  AiService({
    required String apiKey,
    String? baseUrl,
    String? model,
  })  : _apiKey = apiKey,
        _baseUrl = baseUrl ?? 'https://api.openai.com/v1',
        _model = model ?? 'gpt-4o-mini';

  final String _apiKey;
  final String _baseUrl;
  final String _model;

  /// OCR テキストに対して AI 処理を実行し、結果テキストを返す。
  ///
  /// [ocrText] OCR で認識したテキスト。
  /// [promptType] プロンプト種別。
  /// [userInput] フリー入力テキスト（質問/カスタム用）。
  Future<AiResult> process({
    required String ocrText,
    required AiPromptType promptType,
    String? userInput,
  }) async {
    final systemPrompt = promptType.buildSystemPrompt(userInput);
    if (systemPrompt.isEmpty) {
      return const AiResult(
        success: false,
        text: '',
        error: 'プロンプトが空です。',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': ocrText},
          ],
          'max_tokens': 1024,
          'temperature': 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = json['choices'] as List<dynamic>?;
        if (choices != null && choices.isNotEmpty) {
          final message = choices[0]['message'] as Map<String, dynamic>?;
          final content = message?['content'] as String? ?? '';
          debugPrint('[AI] 応答: ${content.length} 文字');
          return AiResult(success: true, text: content.trim());
        }
        return const AiResult(
          success: false,
          text: '',
          error: 'AI からの応答が空でした。',
        );
      } else if (response.statusCode == 401) {
        return const AiResult(
          success: false,
          text: '',
          error: 'API Key が無効です。設定画面で正しいキーを入力してください。',
        );
      } else if (response.statusCode == 429) {
        return const AiResult(
          success: false,
          text: '',
          error: 'API のレート制限に達しました。しばらく待ってからお試しください。',
        );
      } else {
        debugPrint('[AI] エラー: ${response.statusCode} ${response.body}');
        return AiResult(
          success: false,
          text: '',
          error: 'API エラー (${response.statusCode})',
        );
      }
    } catch (e) {
      debugPrint('[AI] 通信エラー: $e');
      return AiResult(
        success: false,
        text: '',
        error: 'ネットワークエラー: インターネット接続を確認してください。',
      );
    }
  }
}

/// AI 処理結果
class AiResult {
  const AiResult({
    required this.success,
    required this.text,
    this.error,
  });

  final bool success;
  final String text;
  final String? error;
}
