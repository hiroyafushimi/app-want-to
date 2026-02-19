import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../screens/paywall_screen.dart';

/// 回数制限到達時のダイアログを表示する。
///
/// データサービス (UsageService) から分離し、UI 層に配置。
Future<void> showUsageLimitDialog(
  BuildContext context, {
  required String featureName,
  required int dailyLimit,
}) {
  final l = AppLocalizations.of(context)!;
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.usageLimitTitle(featureName)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.usageLimitMessage(dailyLimit)),
          const SizedBox(height: 8),
          Text(
            l.usageLimitUpgrade,
            style: TextStyle(
              color: Theme.of(ctx).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l.ok),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PaywallScreen(),
              ),
            );
          },
          child: Text(l.upgrade),
        ),
      ],
    ),
  );
}
