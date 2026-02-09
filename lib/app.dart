import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/region_select_screen.dart';
import 'screens/settings_screen.dart';
import 'services/share_intent_service.dart';

/// Wan to ルートアプリ。
/// 共有シート起点・常駐なし（SPEC_WANT_TO.md 準拠）
class WanToApp extends StatefulWidget {
  const WanToApp({super.key});

  @override
  State<WanToApp> createState() => _WanToAppState();
}

class _WanToAppState extends State<WanToApp> {
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
    debugPrint('[WanTo] getInitialMedia: ${list.length} 件');
    if (list.isNotEmpty) {
      debugPrint('[WanTo] 先頭 path: ${list.first.path}');
      _navigateToRegionSelect(list.first.path);
      await ShareIntentService.reset();
    }
  }

  void _handleShareStream() {
    _shareIntent.mediaStream.listen((list) {
      debugPrint('[WanTo] mediaStream: ${list.length} 件');
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
      title: 'Wan to',
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
      },
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wan to'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: const Center(
        child: Text('共有シートから画像を受信して起動します。'),
      ),
    );
  }
}
