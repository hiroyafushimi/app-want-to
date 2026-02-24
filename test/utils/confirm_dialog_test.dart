import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_to/utils/confirm_dialog.dart';

void main() {
  testWidgets('showConfirmDialog shows dialog and executes onConfirm',
      (tester) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showConfirmDialog(
                context,
                title: 'Delete?',
                content: 'Are you sure?',
                onConfirm: () async {
                  confirmed = true;
                },
                successMessage: 'Deleted!',
                cancelLabel: 'Cancel',
                confirmLabel: 'Delete',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Delete?'), findsOneWidget);
    expect(find.text('Are you sure?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
  });

  testWidgets('onConfirm が実行中はボタンが無効化され連打できない',
      (tester) async {
    var callCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showConfirmDialog(
                context,
                title: 'Delete?',
                content: 'Are you sure?',
                onConfirm: () async {
                  callCount++;
                  await Future<void>.delayed(const Duration(seconds: 1));
                },
                successMessage: 'Deleted!',
                cancelLabel: 'Cancel',
                confirmLabel: 'Delete',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // 1回目のタップで onConfirm を開始
    await tester.tap(find.text('Delete'));
    await tester.pump(); // setState を反映

    // 2回目のタップ（ボタンが無効化されているはず）
    await tester.tap(find.text('Delete'));
    await tester.pump();

    // タイマーを完了させてダイアログを閉じる
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(callCount, 1);
  });

  testWidgets('onConfirm が例外を投げてもダイアログが閉じてボタンが復旧する',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showConfirmDialog(
                context,
                title: 'Delete?',
                content: 'Are you sure?',
                onConfirm: () async {
                  throw Exception('network error');
                },
                successMessage: 'Deleted!',
                cancelLabel: 'Cancel',
                confirmLabel: 'Delete',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // ダイアログが閉じている
    expect(find.text('Delete?'), findsNothing);
  });

  testWidgets('showConfirmDialog cancel does not execute onConfirm',
      (tester) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showConfirmDialog(
                context,
                title: 'Delete?',
                content: 'Are you sure?',
                onConfirm: () async {
                  confirmed = true;
                },
                successMessage: 'Deleted!',
                cancelLabel: 'Cancel',
                confirmLabel: 'Delete',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(confirmed, isFalse);
  });
}
