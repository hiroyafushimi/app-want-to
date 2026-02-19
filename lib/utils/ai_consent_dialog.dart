import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';

/// AI データ送信の同意ダイアログを表示する。
///
/// Apple Guideline 5.1.1(i)/5.1.2(i) 対応:
/// ユーザーに「何のデータが」「誰に」送信されるかを明示し、同意を取得する。
/// ユーザーが「同意する」を選んだ場合 true を返す。
Future<bool> showAiConsentDialog(BuildContext context) async {
  final l = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(l.aiConsentTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.aiConsentMessage),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => launchUrl(
                Uri.parse('https://openai.com/privacy/'),
                mode: LaunchMode.externalApplication,
              ),
              child: Text(
                l.aiConsentPrivacyLink,
                style: TextStyle(
                  color: Theme.of(ctx).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.aiConsentDecline),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.aiConsentAgree),
        ),
      ],
    ),
  );
  return result ?? false;
}
