import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'l10n/app_localizations.dart';
import 'screens/onboarding_screen.dart';
import 'screens/paywall_screen.dart';
import 'screens/region_select_screen.dart';
import 'screens/settings_screen.dart';
import 'services/share_intent_service.dart';

/// ActClip ルートアプリ。
/// 共有シート起点・常駐なし（SPEC_WANT_TO.md 準拠）
class ActClipApp extends StatefulWidget {
  const ActClipApp({super.key});

  @override
  State<ActClipApp> createState() => _ActClipAppState();
}

class _ActClipAppState extends State<ActClipApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final ShareIntentService _shareIntent = ShareIntentService();
  bool _onboardingDone = true; // デフォルト true でフラッシュ防止
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    _handleInitialShare();
    _handleShareStream();
  }

  Future<void> _checkOnboarding() async {
    // メモリ内で簡易管理（MVP）。本番では SharedPreferences で永続化。
    if (mounted) {
      setState(() {
        _onboardingDone = _onboardingCompleted;
        _loaded = true;
      });
    }
  }

  // static フラグ（アプリプロセス内で保持）
  static bool _onboardingCompleted = false;

  void _completeOnboarding() {
    _onboardingCompleted = true;
    setState(() => _onboardingDone = true);
  }

  Future<void> _handleInitialShare() async {
    final list = await _shareIntent.initialMedia;
    debugPrint('[ActClip] getInitialMedia: ${list.length} 件');
    if (list.isNotEmpty) {
      debugPrint('[ActClip] 先頭 path: ${list.first.path}');
      _navigateToRegionSelect(list.first.path);
      await ShareIntentService.reset();
    }
  }

  void _handleShareStream() {
    _shareIntent.mediaStream.listen((list) {
      debugPrint('[ActClip] mediaStream: ${list.length} 件');
      if (list.isNotEmpty) {
        _navigateToRegionSelect(list.first.path);
      }
    });
  }

  void _navigateToRegionSelect(String path) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => RegionSelectScreen(imagePath: path),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'ActClip',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: !_loaded
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _onboardingDone
              ? const _PlaceholderHome()
              : OnboardingScreen(onComplete: _completeOnboarding),
      routes: {
        '/region_select': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final path = args is String ? args : null;
          return RegionSelectScreen(imagePath: path);
        },
        '/settings': (context) => const SettingsScreen(),
        '/paywall': (context) => const PaywallScreen(),
      },
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RegionSelectScreen(imagePath: picked.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.photo_library_outlined, size: 64, color: Colors.blue),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () => _pickImage(context),
                  icon: const Icon(Icons.image),
                  label: Text(l.homePickImage),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.homeOrShareHint,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
