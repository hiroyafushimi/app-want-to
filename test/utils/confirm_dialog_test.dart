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
