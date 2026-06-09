import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/screens/voting/voting_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';

/// صفحه پایان بحث — رای شفاهی + افشای نقش‌های مخفی
class VotingScreen extends ConsumerWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(votingProvider);
    final votingUi = ref.watch(votingProvider);
    final notifier = ref.read(votingProvider.notifier);

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
                  onPressed: notifier.endGameAndReveal,
                ),
              ] else ...[
                AppCard(
                  borderColor: AppColors.accentClassic,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.accentClassic,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'voting.secret_word'.tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        votingUi.revealedSecretWord,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (votingUi.revealedSpies.isNotEmpty)
                  _RoleRevealCard(
                    title: 'voting.spies_were'.tr(),
                    names: votingUi.revealedSpies,
                    accentColor: AppColors.accentDanger,
                    icon: Icons.visibility_off,
                  ),
                if (votingUi.revealedInfiltrators.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _RoleRevealCard(
                    title: 'voting.infiltrators_were'.tr(),
                    names: votingUi.revealedInfiltrators,
                    accentColor: AppColors.accentPremium,
                    icon: Icons.swap_horiz,
                  ),
                ],
                if (votingUi.revealedSpies.isEmpty &&
                    votingUi.revealedInfiltrators.isEmpty)
                  AppCard(
                    child: Text(
                      'voting.no_spies'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                const Spacer(),
                GradientButton(
                  label: 'voting.play_again'.tr(),
                  icon: Icons.replay_rounded,
                  isLoading: votingUi.isRestarting,
                  onPressed: votingUi.isRestarting
                      ? null
                      : () async {
                          // اول ناوبری — جلوگیری از فلش کلمه جدید روی کارت نتیجه
                          context.go(AppRoutes.wordReveal);
                          final started = await notifier.playAgain();
                          if (!context.mounted) return;
                          if (!started) {
                            context.go(AppRoutes.voting);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('error.start_game'.tr()),
                              ),
                            );
                          }
                        },
                ),
                const SizedBox(height: 12),
                OutlinedActionButton(
                  label: 'result.back_home'.tr(),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleRevealCard extends StatelessWidget {
  const _RoleRevealCard({
    required this.title,
    required this.names,
    required this.accentColor,
    required this.icon,
  });

  final String title;
  final List<String> names;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: accentColor,
      child: Column(
        children: [
          Icon(icon, color: accentColor, size: 36),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ...names.map(
            (name) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
