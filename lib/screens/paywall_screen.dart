import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../l10n/app_localizations.dart';
import '../services/iap_service.dart';
import '../utils/safe_set_state.dart';

/// 課金画面（仕様 1.4: 月額¥480 / 買い切り¥2,200）
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> with SafeSetState {
  Offerings? _offerings;
  bool _loading = true;
  bool _purchasing = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final offerings = await IAPService.instance.getOfferings();
    safeSetState(() {
      _offerings = offerings;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.paywallTitle),
        actions: [
          TextButton(
            onPressed: _purchasing ? null : _onRestore,
            child: Text(l.paywallRestore),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(theme, l)),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l) {
    if (_loading) return _buildLoadingView(l);
    if (_offerings?.current == null) return _buildUnavailableView(l);
    return _buildPaywall(theme, l);
  }

  Widget _buildLoadingView(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l.paywallLoading),
        ],
      ),
    );
  }

  Widget _buildUnavailableView(AppLocalizations l) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          l.paywallUnavailable,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildPaywall(ThemeData theme, AppLocalizations l) {
    final pkg = _findLifetimePackage();
    if (pkg == null) return _buildUnavailableView(l);

    final product = pkg.storeProduct;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // ───── アイコン ─────
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          // ───── 特典リスト ─────
          _FeatureRow(icon: Icons.all_inclusive, text: l.paywallFeature1),
          _FeatureRow(icon: Icons.timer_off, text: l.paywallFeature2),
          _FeatureRow(icon: Icons.support_agent, text: l.paywallFeature3),
          const SizedBox(height: 32),

          // ───── 買い切りプラン ─────
          Text(
            l.paywallLifetime,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l.paywallLifetimePrice(product.priceString),
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // ───── 購入ボタン ─────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _purchasing ? null : () => _onPurchase(pkg),
              icon: _purchasing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.shopping_cart),
              label: Text(
                _purchasing ? l.processing : l.upgrade,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ───── 復元ボタン ─────
          TextButton(
            onPressed: _purchasing ? null : _onRestore,
            child: Text(
              l.paywallRestore,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  /// 買い切り（lifetime）パッケージを探す。なければ先頭パッケージ。
  Package? _findLifetimePackage() {
    final packages = _offerings!.current!.availablePackages;
    final lifetime = packages.where(
      (p) => p.packageType == PackageType.lifetime,
    );
    if (lifetime.isNotEmpty) return lifetime.first;
    return packages.isNotEmpty ? packages.first : null;
  }

  // ───── IAP アクション（購入・復元の共通処理） ─────

  Future<void> _performIapAction({
    required Future<bool> Function() action,
    required String successMessage,
    required String failureMessage,
  }) async {
    setState(() => _purchasing = true);
    final success = await action();

    if (!mounted) return;
    safeSetState(() => _purchasing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? successMessage : failureMessage)),
    );
    if (success) Navigator.of(context).pop(true);
  }

  Future<void> _onPurchase(Package pkg) async {
    final l = AppLocalizations.of(context)!;
    await _performIapAction(
      action: () => IAPService.instance.purchase(pkg),
      successMessage: l.paywallPurchaseSuccess,
      failureMessage: l.paywallPurchaseFailed,
    );
  }

  Future<void> _onRestore() async {
    final l = AppLocalizations.of(context)!;
    await _performIapAction(
      action: () => IAPService.instance.restore(),
      successMessage: l.paywallRestoreSuccess,
      failureMessage: l.paywallRestoreNotFound,
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
