import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';

/// صفحه اصلی — منوی بازی
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.gradientPurple,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentDefault.withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.visibility_off,
                  size: 52,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'app.name'.tr(),
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'home.subtitle'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              GradientButton(
                label: 'home.start_game'.tr(),
                icon: Icons.play_arrow_rounded,
                onPressed: () => context.push(AppRoutes.categories),
              ),
              const SizedBox(height: 20),
              _MenuGrid(
                onSettings: () => _showComingSoon(context),
                onRules: () => _showComingSoon(context),
                onAbout: () => _showComingSoon(context),
                onIap: () => _showComingSoon(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('common.coming_soon'.tr()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({
    required this.onSettings,
    required this.onRules,
    required this.onAbout,
    required this.onIap,
  });

  final VoidCallback onSettings;
  final VoidCallback onRules;
  final VoidCallback onAbout;
  final VoidCallback onIap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MenuCard(
                icon: Icons.settings_outlined,
                label: 'home.settings'.tr(),
                onTap: onSettings,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MenuCard(
                icon: Icons.menu_book_outlined,
                label: 'home.rules'.tr(),
                onTap: onRules,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MenuCard(
                icon: Icons.info_outline,
                label: 'home.about'.tr(),
                onTap: onAbout,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MenuCard(
                icon: Icons.workspace_premium_outlined,
                label: 'home.iap'.tr(),
                onTap: onIap,
                accentColor: AppColors.accentPremium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.accentColor = AppColors.accentDefault,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: accentColor, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
