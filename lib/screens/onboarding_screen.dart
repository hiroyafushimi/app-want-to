import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// 初回オンボーディング画面（仕様 7: 3スライド）
///
/// 1. スクショ → 共有 → アプリ選択
/// 2. 囲んで OCR
/// 3. API Key 設定（任意）で AI が使えます
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  /// 完了コールバック
  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  static const _pageCount = 3;

  static const _pageIcons = [Icons.share, Icons.crop_free, Icons.smart_toy];
  static const _pageColors = [Colors.blue, Colors.orange, Colors.green];

  List<_OnboardingPage> _pages(AppLocalizations l) => [
        _OnboardingPage(
          icon: _pageIcons[0],
          title: l.onboarding1Title,
          description: l.onboarding1Desc,
          color: _pageColors[0],
        ),
        _OnboardingPage(
          icon: _pageIcons[1],
          title: l.onboarding2Title,
          description: l.onboarding2Desc,
          color: _pageColors[1],
        ),
        _OnboardingPage(
          icon: _pageIcons[2],
          title: l.onboarding3Title,
          description: l.onboarding3Desc,
          color: _pageColors[2],
        ),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final pages = _pages(l);
    final isLast = _currentPage == _pageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // スキップ
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onComplete,
                child: Text(l.onboardingSkip),
              ),
            ),
            // ページ
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pageCount,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) {
                  final p = pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: p.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(p.icon, size: 56, color: p.color),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          p.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey.shade600,
                                height: 1.6,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // ドットインジケーター
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pageCount,
                (i) => Container(
                  width: i == _currentPage ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // ボタン
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    if (isLast) {
                      widget.onComplete();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(isLast ? l.onboardingStart : l.onboardingNext),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}
