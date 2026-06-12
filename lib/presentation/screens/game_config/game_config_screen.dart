import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/providers/monetization_provider.dart';
import 'package:spy_game/presentation/screens/game_config/game_config_provider.dart';
import 'package:spy_game/presentation/screens/player_setup/player_setup_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/app_snackbar.dart';
import 'package:spy_game/presentation/widgets/counter_card.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/setting_toggle.dart';

/// صفحه تنظیمات دور — تعداد جاسوس، تایمر، قوانین
class GameConfigScreen extends ConsumerWidget {
  const GameConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final configNotifier = ref.read(gameConfigProvider.notifier);
    final configState = ref.watch(gameConfigProvider);
    final isGoldenUser = ref.watch(monetizationProvider).isGoldenUser;
    final timerMinutes = gameState.timerSeconds ~/ 60;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('game_config.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CounterCard(
                            title: 'game_config.player_count'.tr(),
                            value: gameState.playerNames.length,
                            icon: Icons.people_outline,
                            accentColor: AppColors.accentDefault,
                            actionHint: 'game_config.edit_players_hint'.tr(),
                            onTap: () {
                              ref
                                  .read(playerSetupProvider.notifier)
                                  .syncFromGame();
                              context.push(AppRoutes.playerSetup);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CounterCard(
                            title: 'game_config.spy_count'.tr(),
                            value: gameState.spyCount,
                            icon: Icons.visibility_off,
                            accentColor: AppColors.accentDanger,
                            minValue: GameConfig.minSpies,
                            maxValue: configNotifier.maxSpies,
                            onIncrement: configNotifier.incrementSpyCount,
                            onDecrement: configNotifier.decrementSpyCount,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CounterCard(
                    title: 'game_config.timer'.tr(
                      args: [timerMinutes.toString()],
                    ),
                    value: timerMinutes,
                    icon: Icons.timer_outlined,
                    accentColor: AppColors.accentClassic,
                    minValue: GameConfig.minTimerSeconds ~/ 60,
                    maxValue: GameConfig.maxTimerSeconds ~/ 60,
                    onIncrement: configNotifier.incrementTimer,
                    onDecrement: configNotifier.decrementTimer,
                  ),
                  const SizedBox(height: 20),
                  AppCard(
                    onTap: () => context.push(AppRoutes.categories),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.category_outlined,
                          color: AppColors.accentDefault,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'game_config.categories'.tr(),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'game_config.categories_selected'.tr(
                                  args: [
                                    gameState.selectedCategoryIds.length
                                        .toString(),
                                  ],
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // کارت مربع کنار هم — ارتفاع صریح از عرض ستون
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const gap = 12.0;
                      final cardWidth = (constraints.maxWidth - gap) / 2;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            height: cardWidth,
                            child: _PremiumRoleToggle(
                              title: 'game_config.has_detective'.tr(),
                              helpBodyKey: 'game_config.detective_help_detail',
                              icon: Icons.search_outlined,
                              value: gameState.hasDetective,
                              enabled: isGoldenUser &&
                                  configNotifier.canEnableDetective,
                              onChanged: configNotifier.setHasDetective,
                              onPremiumTap: isGoldenUser
                                  ? null
                                  : () => context.push(AppRoutes.iap),
                            ),
                          ),
                          const SizedBox(width: gap),
                          SizedBox(
                            width: cardWidth,
                            height: cardWidth,
                            child: _PremiumRoleToggle(
                              title: 'game_config.has_infiltrator'.tr(),
                              helpBodyKey:
                                  'game_config.infiltrator_help_detail',
                              icon: Icons.theater_comedy_outlined,
                              value: gameState.hasInfiltrator,
                              enabled: isGoldenUser &&
                                  configNotifier.canEnableInfiltrator,
                              onChanged: configNotifier.setHasInfiltrator,
                              onPremiumTap: isGoldenUser
                                  ? null
                                  : () => context.push(AppRoutes.iap),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SettingToggle(
                    title: 'game_config.show_category_spy'.tr(),
                    icon: Icons.category,
                    value: gameState.showCategoryForSpy,
                    accentColor: AppColors.accentDefault,
                    onChanged: configNotifier.setShowCategoryForSpy,
                  ),
                  const SizedBox(height: 12),
                  SettingToggle(
                    title: 'game_config.spy_hint'.tr(),
                    icon: Icons.lightbulb_outline,
                    value: gameState.spyHintEnabled,
                    accentColor: AppColors.accentPremium,
                    onChanged: configNotifier.setSpyHintEnabled,
                  ),
                  const SizedBox(height: 12),
                  SettingToggle(
                    title: 'game_config.spies_know_each_other'.tr(),
                    icon: Icons.group_outlined,
                    value: gameState.spiesKnowEachOther,
                    accentColor: AppColors.accentClassic,
                    onChanged: configNotifier.setSpiesKnowEachOther,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GradientButton(
                label: 'game_config.start_game'.tr(),
                icon: Icons.play_arrow_rounded,
                enabled: gameState.canStartGame,
                isLoading: configState.isStarting,
                onPressed: gameState.canStartGame
                    ? () async {
                        final started =
                            await configNotifier.startGame();
                        if (!context.mounted) return;
                        if (started) {
                          context.go(AppRoutes.wordReveal);
                        } else {
                          AppSnackBar.error(
                            context,
                            'error.start_game'.tr(),
                          );
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نمایش مودال راهنمای نقش ویژه
Future<void> _showRoleHelpDialog(
  BuildContext context, {
  required String title,
  required String body,
  required IconData icon,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.accentPremium, size: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(dialogContext).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('game_config.role_help_understood'.tr()),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// آیکن گوشه کارت — راهنما یا قفل با اندازه یکسان
class _CornerIconButton extends StatelessWidget {
  const _CornerIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  static const double _size = 28;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

/// سوئیچ نقش ویژه با نشان PRO و راهنما — کنار هم در یک ردیف
class _PremiumRoleToggle extends StatelessWidget {
  const _PremiumRoleToggle({
    required this.title,
    required this.helpBodyKey,
    required this.icon,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.onPremiumTap,
  });

  final String title;
  final String helpBodyKey;
  final IconData icon;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onPremiumTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        // بچه غیر Positioned — محدودیت مربع را به کارت می‌دهد
        GestureDetector(
          onTap: onPremiumTap,
          behavior: HitTestBehavior.translucent,
          child: SettingToggle(
            title: title,
            icon: icon,
            value: value,
            enabled: enabled,
            compact: true,
            compactTopInset: 34,
            expand: true,
            accentColor: AppColors.accentPremium,
            onChanged: onChanged,
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: 8,
          end: 8,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CornerIconButton(
                icon: Icons.help_outline,
                color: AppColors.primaryBlue,
                onTap: () => _showRoleHelpDialog(
                  context,
                  title: title,
                  body: helpBodyKey.tr(),
                  icon: icon,
                ),
              ),
              const SizedBox(width: 6),
              IgnorePointer(
                ignoring: onPremiumTap == null,
                child: _CornerIconButton(
                  icon: Icons.lock_outline,
                  color: AppColors.accentPremium,
                  onTap: onPremiumTap ?? () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
