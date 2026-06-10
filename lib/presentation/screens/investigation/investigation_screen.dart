import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/investigation/investigation_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';

/// صفحه بازجویی کاراگاه — یک بار قبل از رای‌گیری
class InvestigationScreen extends ConsumerWidget {
  const InvestigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    ref.watch(investigationProvider);
    final notifier = ref.read(investigationProvider.notifier);
    final detective = game.aliveDetective;
    final targets = notifier.investigationTargets;

    ref.listen(gameProvider, (previous, next) {
      if (next.phase == GamePhase.voting) {
        context.go(AppRoutes.voting);
      }
    });

    if (game.phase != GamePhase.investigation || detective == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accentDefault),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('investigation.title'.tr()),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'investigation.round'.tr(args: [game.roundNumber.toString()]),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (!game.isInvestigationComplete) ...[
                const Icon(
                  Icons.search,
                  size: 56,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(height: 16),
                Text(
                  'investigation.pass_phone'.tr(
                    args: [detective.playerName],
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'investigation.select_hint'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: targets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final target = targets[index];
                      return _InvestigationTargetTile(
                        name: target.playerName,
                        onTap: () => notifier.selectTarget(target.playerName),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Spacer(),
                AppCard(
                  borderColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.fact_check_outlined,
                        size: 48,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'investigation.result_title'.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game.investigationTargetName ?? '',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _apparentRoleLabel(game.investigationResultRole),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _apparentRoleColor(
                                game.investigationResultRole,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'investigation.result_hint'.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GradientButton(
                  label: 'investigation.continue_voting'.tr(),
                  icon: Icons.how_to_vote_outlined,
                  onPressed: notifier.proceedToVoting,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _apparentRoleLabel(GameRole? role) {
    return switch (role) {
      GameRole.spy => 'investigation.appears_spy'.tr(),
      GameRole.citizen => 'investigation.appears_citizen'.tr(),
      _ => 'investigation.appears_citizen'.tr(),
    };
  }

  Color _apparentRoleColor(GameRole? role) {
    return role == GameRole.spy
        ? AppColors.accentDanger
        : AppColors.accentClassic;
  }
}

/// کارت انتخاب بازیکن برای بازجویی
class _InvestigationTargetTile extends StatelessWidget {
  const _InvestigationTargetTile({
    required this.name,
    required this.onTap,
  });

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial =
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
            child: Text(
              initial,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
