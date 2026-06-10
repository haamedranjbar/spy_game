import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/screens/voting/voting_provider.dart';
import 'package:spy_game/presentation/widgets/app_snackbar.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';
import 'package:spy_game/presentation/widgets/result_tile.dart';

/// صفحه پایان بحث — رای شفاهی + افشای نقش‌های مخفی
class VotingScreen extends ConsumerWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(votingProvider);
    final votingUi = ref.watch(votingProvider);
    final notifier = ref.read(votingProvider.notifier);

    final resultTiles = <Widget>[
      ResultTile(
        label: 'voting.secret_word'.tr(),
        value: votingUi.revealedSecretWord,
        icon: Icons.lightbulb_outline,
        accentColor: AppColors.accentClassic,
      ),
      ...votingUi.revealedSpies.map(
        (name) => ResultTile(
          label: 'role.spy'.tr(),
          value: name,
          icon: Icons.visibility_off,
          accentColor: AppColors.accentDanger,
        ),
      ),
      ...votingUi.revealedInfiltrators.map(
        (name) => ResultTile(
          label: 'role.infiltrator'.tr(),
          value: name,
          icon: Icons.swap_horiz,
          accentColor: AppColors.accentPremium,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('voting.title'.tr()),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!votingUi.rolesRevealed) ...[
                const Spacer(),
                const Icon(
                  Icons.record_voice_over_outlined,
                  size: 64,
                  color: AppColors.accentDefault,
                ),
                const SizedBox(height: 20),
                Text(
                  'voting.verbal_hint'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'voting.verbal_subhint'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                GradientButton(
                  label: 'voting.end_game'.tr(),
                  icon: Icons.flag_outlined,
                  gradientColors: const [
                    AppColors.accentDanger,
                    AppColors.primaryRed,
                  ],
                  onPressed: notifier.endGameAndReveal,
                ),
              ] else ...[
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: ResultTile.tileHeight,
                    ),
                    itemCount: resultTiles.length,
                    itemBuilder: (context, index) => resultTiles[index],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        label: 'voting.play_again'.tr(),
                        icon: Icons.replay_rounded,
                        isLoading: votingUi.isRestarting,
                        onPressed: votingUi.isRestarting
                            ? null
                            : () async {
                                context.go(AppRoutes.wordReveal);
                                final started = await notifier.playAgain();
                                if (!context.mounted) return;
                                if (!started) {
                                  context.go(AppRoutes.voting);
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
                      onPressed: votingUi.isRestarting
                          ? null
                          : () {
                              notifier.endGame();
                              context.go(AppRoutes.home);
                            },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
