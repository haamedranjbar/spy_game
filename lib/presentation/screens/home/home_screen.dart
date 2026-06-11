import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/player_setup/player_setup_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/exit_confirm_scope.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';

/// ارتفاع یکسان دکمه‌های پایین صفحه اصلی — دوبرابر دکمه استاندارد
const double kHomeButtonHeight = 104;

/// صفحه اصلی — منوی بازی
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExitConfirmScope(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // فضای خالی بالا — بعداً تصویر زمینه اضافه می‌شود
                const Spacer(),
                GradientButton(
                  label: 'home.start_game'.tr(),
                  icon: Icons.play_arrow_rounded,
                  height: kHomeButtonHeight,
                  onPressed: () {
                    // شروع بازی جدید: بازیکنان → دسته‌ها → تنظیمات
                    ref.read(gameProvider.notifier).resetGame();
                    ref.invalidate(playerSetupProvider);
                    context.push(AppRoutes.playerSetupNewGame);
                  },
                ),
                const SizedBox(height: 12),
                _MenuGrid(
                  buttonHeight: kHomeButtonHeight,
                  onSettings: () => context.push(AppRoutes.settings),
                  onRules: () => context.push(AppRoutes.rules),
                  onAbout: () => context.push(AppRoutes.about),
                  onIap: () => context.push(AppRoutes.iap),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({
    required this.buttonHeight,
    required this.onSettings,
    required this.onRules,
    required this.onAbout,
    required this.onIap,
  });

  final double buttonHeight;
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
                height: buttonHeight,
                icon: Icons.settings_outlined,
                label: 'home.settings'.tr(),
                onTap: onSettings,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MenuCard(
                height: buttonHeight,
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
                height: buttonHeight,
                icon: Icons.info_outline,
                label: 'home.about'.tr(),
                onTap: onAbout,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MenuCard(
                height: buttonHeight,
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
    required this.height,
    required this.icon,
    required this.label,
    required this.onTap,
    this.accentColor = AppColors.accentDefault,
  });

  final double height;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentColor, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
