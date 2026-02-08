import 'package:flutter/material.dart';

import 'screens/received_image_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _handleInitialShare();
    _handleShareStream();
  }

  Future<void> _handleInitialShare() async {
    final list = await _shareIntent.initialMedia;
    if (list.isNotEmpty) {
      _navigateToReceivedImage(list.first.path);
      await ShareIntentService.reset();
    }
  }

  void _handleShareStream() {
    _shareIntent.mediaStream.listen((list) {
      if (list.isNotEmpty) {
        _navigateToReceivedImage(list.first.path);
      }
    });
  }

  void _navigateToReceivedImage(String path) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ReceivedImageScreen(imagePath: path),
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
      home: const _PlaceholderHome(),
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
