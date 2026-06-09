import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/game_config/game_config_provider.dart';
import 'package:spy_game/presentation/screens/player_setup/player_setup_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
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
                  SettingToggle(
                    title: 'game_config.show_category_spy'.tr(),
                    icon: Icons.category,
                    value: gameState.showCategoryForSpy,
                    onChanged: configNotifier.setShowCategoryForSpy,
                  ),
                  const SizedBox(height: 12),
                  SettingToggle(
                    title: 'game_config.spy_hint'.tr(),
                    icon: Icons.lightbulb_outline,
                    value: gameState.spyHintEnabled,
                    onChanged: configNotifier.setSpyHintEnabled,
                  ),
                  const SizedBox(height: 12),
                  SettingToggle(
                    title: 'game_config.spies_know_each_other'.tr(),
                    icon: Icons.group_outlined,
                    value: gameState.spiesKnowEachOther,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('error.start_game'.tr()),
                            ),
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
