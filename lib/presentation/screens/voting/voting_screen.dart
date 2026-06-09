import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/voting/voting_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';

/// صفحه رای‌گیری — هر بازیکن یک نفر را انتخاب می‌کند
class VotingScreen extends ConsumerWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final votingUi = ref.watch(votingProvider);
    final notifier = ref.read(votingProvider.notifier);
    final currentVoter = game.currentVotingPlayer;

    ref.listen(gameProvider, (previous, next) {
      if (next.phase == GamePhase.result) {
        context.go(AppRoutes.result);
      }
    });

    if (currentVoter == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accentDefault),
        ),
      );
    }

    final candidates = game.aliveRoles
        .where((role) => role.playerName != currentVoter.playerName)
        .toList();
    final progress = game.currentVotingIndex + 1;
    final total = game.aliveRoles.length;

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'voting.player_turn'.tr(
                  args: [currentVoter.playerName, '$progress', '$total'],
                ),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'voting.select_player'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: candidates.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final candidate = candidates[index];
                    final isSelected =
                        votingUi.selectedPlayerName == candidate.playerName;

                    return AppCard(
                      onTap: () => notifier.selectPlayer(candidate.playerName),
                      isSelected: isSelected,
                      selectedGlowColor: AppColors.accentDefault,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                AppColors.accentDefault.withValues(alpha: 0.2),
                            child: Text(
                              candidate.playerName.isNotEmpty
                                  ? candidate.playerName
                                      .substring(0, 1)
                                      .toUpperCase()
                                  : '?',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.accentDefault,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              candidate.playerName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.accentDefault,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              GradientButton(
                label: 'voting.submit'.tr(),
                icon: Icons.how_to_vote_outlined,
                enabled: votingUi.selectedPlayerName != null,
                onPressed: votingUi.selectedPlayerName != null
                    ? notifier.submitVote
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
