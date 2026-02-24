import 'package:flutter_test/flutter_test.dart';
import 'package:want_to/services/ai_service.dart';
import 'package:want_to/services/demo_ai_service.dart';

void main() {
  late DemoAiService service;

  setUp(() {
    service = DemoAiService();
  });

  for (final type in AiPromptType.values) {
    test('${type.name} で成功し isDemo が true', () async {
      final result = await service.process(
        ocrText: 'テスト文章',
        promptType: type,
        userInput: type.needsUserInput ? 'テスト入力' : null,
      );

      expect(result.success, isTrue);
      expect(result.isDemo, isTrue);
      expect(result.text, isNotEmpty);
      expect(result.error, isNull);
    });
  }

  test('異なるプロンプト種別で異なる応答を返す', () async {
    final summary = await service.process(
      ocrText: 'テスト',
      promptType: AiPromptType.summary,
    );
    final translate = await service.process(
      ocrText: 'テスト',
      promptType: AiPromptType.translate,
    );

    expect(summary.text, isNot(equals(translate.text)));
  });
}
