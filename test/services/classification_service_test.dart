import 'package:flutter_test/flutter_test.dart';
import 'package:want_to/services/classification_service.dart';

void main() {
  group('ClassificationService.classify', () {
    // ── 商品判定: キーワード ──

    test('¥ 記号を含むテキストは product と判定される', () {
      expect(
        ClassificationService.classify('商品 ¥1,200'),
        ClassificationType.product,
      );
    });

    test('円 を含むテキストは product と判定される', () {
      expect(
        ClassificationService.classify('送料無料 1000円'),
        ClassificationType.product,
      );
    });

    test('Amazon を含むテキストは product と判定される', () {
      expect(
        ClassificationService.classify('Amazon限定品'),
        ClassificationType.product,
      );
    });

    test('楽天 を含むテキストは product と判定される', () {
      expect(
        ClassificationService.classify('楽天セール開催中'),
        ClassificationType.product,
      );
    });

    test('セール を含むテキストは product と判定される', () {
      expect(
        ClassificationService.classify('セール品'),
        ClassificationType.product,
      );
    });

    // ── 商品判定: 正規表現 ──

    test('カンマ付き円表記にマッチする', () {
      expect(
        ClassificationService.classify('特価 1,980円'),
        ClassificationType.product,
      );
    });

    test('¥ + 数字 パターンにマッチする', () {
      expect(
        ClassificationService.classify('¥500 割引'),
        ClassificationType.product,
      );
    });

    test('amazon.co.jp URL にマッチする', () {
      expect(
        ClassificationService.classify('https://amazon.co.jp/dp/B0123'),
        ClassificationType.product,
      );
    });

    test('rakuten.co.jp URL にマッチする', () {
      expect(
        ClassificationService.classify('https://item.rakuten.co.jp/shop/item1'),
        ClassificationType.product,
      );
    });

    test('% OFF パターンにマッチする', () {
      expect(
        ClassificationService.classify('今だけ 30% OFF'),
        ClassificationType.product,
      );
    });

    // ── 文章判定 ──

    test('20文字以上の商品キーワードなしテキストは text と判定される', () {
      expect(
        ClassificationService.classify('これは二十文字以上ある文章のテストです。'),
        ClassificationType.text,
      );
    });

    test('ちょうど20文字のテキストは text と判定される', () {
      // 20文字ちょうど（商品キーワードなし）
      const text = 'abcdefghijklmnopqrst'; // 20 chars
      expect(text.length, 20);
      expect(
        ClassificationService.classify(text),
        ClassificationType.text,
      );
    });

    // ── その他判定 ──

    test('19文字以下のテキストは other と判定される', () {
      const text = 'abcdefghijklmnopqrs'; // 19 chars
      expect(text.length, 19);
      expect(
        ClassificationService.classify(text),
        ClassificationType.other,
      );
    });

    test('短いテキストは other と判定される', () {
      expect(
        ClassificationService.classify('hello'),
        ClassificationType.other,
      );
    });

    test('空文字列は other と判定される', () {
      expect(
        ClassificationService.classify(''),
        ClassificationType.other,
      );
    });

    test('空白のみは other と判定される', () {
      expect(
        ClassificationService.classify('   '),
        ClassificationType.other,
      );
    });
  });

  group('ClassificationService.extractProductQuery', () {
    test('URL を除去する', () {
      final result = ClassificationService.extractProductQuery(
        '商品名 https://example.com/path 説明',
      );
      expect(result, isNot(contains('https://')));
      expect(result, contains('商品名'));
    });

    test('¥ 価格表記を除去する', () {
      final result = ClassificationService.extractProductQuery(
        'ワイヤレスイヤホン ¥3,980 送料無料',
      );
      expect(result, isNot(contains('¥3,980')));
      expect(result, contains('ワイヤレスイヤホン'));
    });

    test('円 価格表記を除去する', () {
      final result = ClassificationService.extractProductQuery(
        'Bluetoothスピーカー 2,500円 税込',
      );
      expect(result, isNot(contains('2,500円')));
      expect(result, contains('Bluetoothスピーカー'));
    });

    test('% OFF を除去する', () {
      final result = ClassificationService.extractProductQuery(
        '人気商品 50% OFF セール中',
      );
      expect(result, isNot(contains('50% OFF')));
    });

    test('括弧類を空白に変換する', () {
      final result = ClassificationService.extractProductQuery(
        '【新品】商品名「テスト」',
      );
      expect(result, isNot(contains('【')));
      expect(result, isNot(contains('】')));
      expect(result, contains('新品'));
      expect(result, contains('商品名'));
    });

    test('60文字を超える場合は先頭60文字に切り詰める', () {
      final longText = 'あ' * 100;
      final result = ClassificationService.extractProductQuery(longText);
      expect(result.length, 60);
    });

    test('空文字列から空文字列を返す', () {
      final result = ClassificationService.extractProductQuery('');
      expect(result, isEmpty);
    });
  });
}
