import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../l10n/app_localizations.dart';
import '../services/iap_service.dart';

/// 課金画面（仕様 1.4: 月額¥480 / 買い切り¥2,200）
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
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
    if (mounted) {
      setState(() {
        _offerings = offerings;
        _loading = false;
      });
    }
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
      body: SafeArea(
        child: _loading
            ? Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l.paywallLoading),
                ],
              ))
            : _offerings == null || _offerings!.current == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l.paywallUnavailable,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                : _buildPaywall(theme, l),
      ),
    );
  }

  Widget _buildPaywall(ThemeData theme, AppLocalizations l) {
    final offering = _offerings!.current!;
    // 買い切り（lifetime）パッケージのみ使用
    final lifetimePkg = offering.availablePackages.where(
      (p) => p.packageType == PackageType.lifetime,
    );
    final pkg = lifetimePkg.isNotEmpty
        ? lifetimePkg.first
        : offering.availablePackages.isNotEmpty
            ? offering.availablePackages.first
            : null;

    if (pkg == null) {
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

  Future<void> _onPurchase(Package pkg) async {
    setState(() => _purchasing = true);
    final l = AppLocalizations.of(context)!;

    final success = await IAPService.instance.purchase(pkg);

    if (!mounted) return;
    setState(() => _purchasing = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.paywallPurchaseSuccess)),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.paywallPurchaseFailed)),
      );
    }
  }

  Future<void> _onRestore() async {
    setState(() => _purchasing = true);
    final l = AppLocalizations.of(context)!;

    final success = await IAPService.instance.restore();

    if (!mounted) return;
    setState(() => _purchasing = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.paywallRestoreSuccess)),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.paywallRestoreNotFound)),
      );
    }
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
