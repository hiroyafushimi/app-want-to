import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_to/utils/snackbar_helper.dart';

void main() {
  testWidgets('showSnackBarMessage displays a SnackBar with given text',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => context.showSnackBarMessage('Test message'),
              child: const Text('Tap'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap'));
    await tester.pump();

    expect(find.text('Test message'), findsOneWidget);
  });

  testWidgets('showSnackBarMessage accepts optional duration parameter',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => context.showSnackBarMessage(
                'Custom duration',
                duration: const Duration(seconds: 1),
              ),
              child: const Text('Tap'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap'));
    await tester.pump();
    expect(find.text('Custom duration'), findsOneWidget);
  });
}
