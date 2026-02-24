import 'package:flutter/material.dart';

import 'snackbar_helper.dart';

/// 確認ダイアログを表示する汎用ヘルパー。
///
/// [onConfirm] 実行後、ダイアログを閉じて [successMessage] を SnackBar で表示する。
Future<void> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Future<void> Function() onConfirm,
  required String successMessage,
  required String cancelLabel,
  required String confirmLabel,
  Color? confirmColor,
}) {
  var isExecuting = false;

  return showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: isExecuting ? null : () => Navigator.pop(ctx),
            child: Text(cancelLabel),
          ),
          FilledButton(
            style: confirmColor != null
                ? FilledButton.styleFrom(backgroundColor: confirmColor)
                : null,
            onPressed: isExecuting
                ? null
                : () async {
                    setState(() => isExecuting = true);
                    try {
                      await onConfirm();
                      if (context.mounted) {
                        context.showSnackBarMessage(successMessage);
                      }
                    } on Exception {
                      // onConfirm の例外時はダイアログを閉じるだけにする
                    } finally {
                      if (ctx.mounted) Navigator.pop(ctx);
                    }
                  },
            child: Text(confirmLabel),
          ),
        ],
      ),
    ),
  );
}
