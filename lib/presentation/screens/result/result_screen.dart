import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/result/result_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/app_snackbar.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';

/// صفحه نتیجه دور — حذف‌شده و برنده
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final resultUi = ref.watch(resultProvider);
    final notifier = ref.read(resultProvider.notifier);

    final eliminatedName = game.eliminatedPlayerName;
    final eliminatedRole = game.eliminatedRole;
    final hasWinner = game.winner != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('result.title'.tr(args: [game.roundNumber.toString()])),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (eliminatedName != null && eliminatedRole != null)
                AppCard(
                  borderColor: AppColors.accentDanger,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_off_outlined,
                        color: AppColors.accentDanger,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'result.eliminated'.tr(args: [eliminatedName]),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'result.role_was'.tr(
                          args: [_roleLabel(eliminatedRole)],
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              if (hasWinner) ...[
                const SizedBox(height: 20),
                AppCard(
                  borderColor: game.winner == GameWinner.citizens
                      ? AppColors.accentDefault
                      : AppColors.accentDanger,
                  child: Column(
                    children: [
                      Icon(
                        game.winner == GameWinner.citizens
                            ? Icons.emoji_events_outlined
                            : Icons.visibility_off,
                        color: game.winner == GameWinner.citizens
                            ? AppColors.accentDefault
                            : AppColors.accentDanger,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game.winner == GameWinner.citizens
                            ? 'result.citizens_win'.tr()
                            : 'result.spies_win'.tr(),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                Text(
                  'result.continue_hint'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              const Spacer(),
              if (game.isGameOver)
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        label: 'voting.play_again'.tr(),
                        icon: Icons.replay_rounded,
                        isLoading: resultUi.isRestarting,
                        onPressed: resultUi.isRestarting
                            ? null
                            : () async {
                                context.go(AppRoutes.wordReveal);
                                final started = await notifier.playAgain();
                                if (!context.mounted) return;
                                if (!started) {
                                  context.go(AppRoutes.result);
                                  AppSnackBar.error(
                                    context,
                                    'error.start_game'.tr(),
                                  );
                                }
                              },
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedActionButton(
                      label: '',
                      iconOnly: true,
                      icon: Icons.home_outlined,
                      color: AppColors.textSecondary,
                      onPressed: resultUi.isRestarting
                          ? null
                          : () {
                              notifier.endGame();
                              context.go(AppRoutes.home);
                            },
                    ),
                  ],
                )
              else ...[
                GradientButton(
                  label: 'result.continue_game'.tr(),
                  icon: Icons.replay_rounded,
                  isLoading: resultUi.isLoadingNext,
                  onPressed: () async {
                    final started = await notifier.continueGame();
                    if (!context.mounted) return;
                    if (started) {
                      context.go(AppRoutes.wordReveal);
                    }
                  },
                ),
                const SizedBox(height: 12),
                OutlinedActionButton(
                  label: 'result.back_home'.tr(),
                  onPressed: () {
                    notifier.endGame();
                    context.go(AppRoutes.home);
                  },
                  color: AppColors.textSecondary,
                  icon: Icons.home_outlined,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _roleLabel(GameRole role) {
    return switch (role) {
      GameRole.citizen => 'role.citizen'.tr(),
      GameRole.spy => 'role.spy'.tr(),
      GameRole.detective => 'role.detective'.tr(),
      GameRole.infiltrator => 'role.infiltrator'.tr(),
    };
  }
}
