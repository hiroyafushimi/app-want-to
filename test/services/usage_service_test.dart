import 'package:flutter_test/flutter_test.dart';
import 'package:want_to/services/usage_service.dart';

void main() {
  group('UsageService - OCR', () {
    late UsageService service;

    setUp(() {
      service = UsageService.forTest(
        clock: () => DateTime(2026, 1, 15),
      );
    });

    test('初期状態で canUseOcr は true', () {
      expect(service.canUseOcr, isTrue);
    });

    test('初期状態の remainingOcr は freeOcrLimit と等しい', () {
      expect(service.remainingOcr, UsageService.freeOcrLimit);
    });

    test('consumeOcr で残り回数が減る', () {
      service.consumeOcr();
      expect(service.remainingOcr, UsageService.freeOcrLimit - 1);
    });

    test('上限まで使うと canUseOcr が false になる', () {
      for (var i = 0; i < UsageService.freeOcrLimit; i++) {
        expect(service.consumeOcr(), isTrue);
      }
      expect(service.canUseOcr, isFalse);
      expect(service.remainingOcr, 0);
    });

    test('上限到達後の consumeOcr は false を返す', () {
      for (var i = 0; i < UsageService.freeOcrLimit; i++) {
        service.consumeOcr();
      }
      expect(service.consumeOcr(), isFalse);
    });
  });

  group('UsageService - AI', () {
    late UsageService service;

    setUp(() {
      service = UsageService.forTest(
        clock: () => DateTime(2026, 1, 15),
      );
    });

    test('初期状態で canUseAi は true', () {
      expect(service.canUseAi, isTrue);
    });

    test('初期状態の remainingAi は freeAiLimit と等しい', () {
      expect(service.remainingAi, UsageService.freeAiLimit);
    });

    test('上限まで使うと canUseAi が false になる', () {
      for (var i = 0; i < UsageService.freeAiLimit; i++) {
        expect(service.consumeAi(), isTrue);
      }
      expect(service.canUseAi, isFalse);
      expect(service.remainingAi, 0);
    });

    test('上限到達後の consumeAi は false を返す', () {
      for (var i = 0; i < UsageService.freeAiLimit; i++) {
        service.consumeAi();
      }
      expect(service.consumeAi(), isFalse);
    });
  });

  group('UsageService - 日付リセット', () {
    test('日付が変わるとカウンターがリセットされる', () {
      var currentDate = DateTime(2026, 1, 15);
      final service = UsageService.forTest(clock: () => currentDate);

      // 1日目: 上限まで使う
      for (var i = 0; i < UsageService.freeOcrLimit; i++) {
        service.consumeOcr();
      }
      expect(service.canUseOcr, isFalse);

      // 翌日に進める
      currentDate = DateTime(2026, 1, 16);

      // リセットされている
      expect(service.canUseOcr, isTrue);
      expect(service.remainingOcr, UsageService.freeOcrLimit);
    });

    test('AI カウンターも日付変更でリセットされる', () {
      var currentDate = DateTime(2026, 1, 15);
      final service = UsageService.forTest(clock: () => currentDate);

      for (var i = 0; i < UsageService.freeAiLimit; i++) {
        service.consumeAi();
      }
      expect(service.canUseAi, isFalse);

      currentDate = DateTime(2026, 1, 16);
      expect(service.canUseAi, isTrue);
    });
  });

  group('UsageService - Premium', () {
    late UsageService service;

    setUp(() {
      service = UsageService.forTest(
        clock: () => DateTime(2026, 1, 15),
      );
      service.isPremium = true;
    });

    test('Premium ユーザーは canUseOcr が常に true', () {
      // 無料上限を超えて使っても true
      for (var i = 0; i < UsageService.freeOcrLimit + 10; i++) {
        expect(service.consumeOcr(), isTrue);
      }
      expect(service.canUseOcr, isTrue);
    });

    test('Premium ユーザーは canUseAi が常に true', () {
      for (var i = 0; i < UsageService.freeAiLimit + 10; i++) {
        expect(service.consumeAi(), isTrue);
      }
      expect(service.canUseAi, isTrue);
    });

    test('Premium ユーザーの remainingOcr は -1（無制限）', () {
      expect(service.remainingOcr, -1);
    });

    test('Premium ユーザーの remainingAi は -1（無制限）', () {
      expect(service.remainingAi, -1);
    });
  });
}
