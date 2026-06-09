import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/core/utils/category_name.dart';
import 'package:spy_game/core/utils/spy_reveal.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/word_reveal/word_reveal_provider.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/role_card.dart';

/// صفحه نمایش نقش و کلمه — pass the phone
class WordRevealScreen extends ConsumerWidget {
  const WordRevealScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    ref.watch(wordRevealProvider);
    final notifier = ref.read(wordRevealProvider.notifier);
    final categoryAsync = ref.watch(secretWordCategoryProvider);
    final currentPlayer = game.currentRevealPlayer;
    final aliveCount = game.aliveRoles.length;

    ref.listen(gameProvider, (previous, next) {
      if (next.phase == GamePhase.timer) {
        context.go(AppRoutes.timer);
      }
    });

    if (currentPlayer == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accentDefault),
        ),
      );
    }

    final categoryName = categoryAsync.value != null
        ? localizedCategoryName(categoryAsync.value!, context.locale)
        : null;

    final revealInfo = buildRoleRevealInfo(
      player: currentPlayer,
      secretWord: game.secretWord,
      showCategoryForSpy: game.showCategoryForSpy,
      spyHintEnabled: game.spyHintEnabled,
      spiesKnowEachOther: game.spiesKnowEachOther,
      aliveRoles: game.aliveRoles,
      categoryName: categoryName,
    );

    final progress = game.currentRevealIndex + 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('word_reveal.title'.tr()),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'word_reveal.player_turn'.tr(
                  args: [currentPlayer.playerName, '$progress', '$aliveCount'],
                ),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'word_reveal.pass_phone'.tr(args: [currentPlayer.playerName]),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              RoleCard(
                roleKey: currentPlayer.roleKey,
                isRevealed: game.isCurrentRevealed,
                word: revealInfo.word,
                categoryName: revealInfo.categoryName,
                spyHint: revealInfo.spyHint,
                coSpyNames: revealInfo.coSpyNames,
                onReveal: game.isCurrentRevealed ? null : notifier.reveal,
                accentColor: currentPlayer.role == GameRole.spy
                    ? AppColors.accentDanger
                    : AppColors.accentDefault,
              ),
              const Spacer(),
              GradientButton(
                label: progress < aliveCount
                    ? 'word_reveal.next_player'.tr()
                    : 'word_reveal.start_timer'.tr(),
                icon: Icons.arrow_forward_rounded,
                enabled: game.isCurrentRevealed,
                onPressed: game.isCurrentRevealed ? notifier.nextPlayer : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
