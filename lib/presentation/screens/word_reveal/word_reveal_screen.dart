import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:spy_game/core/constants/app_colors.dart';

import 'package:spy_game/core/router/router.dart';

import 'package:spy_game/core/utils/category_name.dart';

import 'package:spy_game/core/utils/spy_reveal.dart';

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



    if (game.phase != GamePhase.wordReveal || currentPlayer == null) {

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



    // ایندکس دقیق بازیکن در لیست کامل نقش‌ها برای شناسایی جاسوس‌های دیگر

    final playerIndex = game.roles.indexOf(currentPlayer);

    final safeIndex =

        playerIndex >= 0 ? playerIndex : game.currentRevealIndex;



    final revealInfo = buildRoleRevealInfo(

      player: currentPlayer,

      currentPlayerIndex: safeIndex,

      secretWord: game.secretWord,

      showCategoryForSpy: game.showCategoryForSpy,

      spyHintEnabled: game.spyHintEnabled,

      spiesKnowEachOther: game.spiesKnowEachOther,

      allRoles: game.roles,

      categoryName: categoryName,

    );



    final progress = game.currentRevealIndex + 1;



    return Scaffold(

      backgroundColor: AppColors.background,

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(

            children: [

              _ProgressPill(

                label: '$progress / $aliveCount',

              ),

              const SizedBox(height: 28),

              Text(

                currentPlayer.playerName.toUpperCase(),

                style: Theme.of(context).textTheme.headlineMedium?.copyWith(

                      color: AppColors.textPrimary,

                      fontWeight: FontWeight.w800,

                      letterSpacing: 0.5,

                    ),

                textAlign: TextAlign.center,

              ),

              const SizedBox(height: 8),

              Text(

                game.isCurrentRevealed

                    ? 'word_reveal.check_complete'.tr()

                    : 'word_reveal.tap_to_check'.tr(),

                style: Theme.of(context).textTheme.bodyMedium?.copyWith(

                      color: AppColors.textSecondary,

                    ),

                textAlign: TextAlign.center,

              ),

              const Spacer(),

              RoleCard(

                key: ValueKey(

                  'reveal_${safeIndex}_${currentPlayer.playerName}',

                ),

                role: currentPlayer.role,

                roleKey: currentPlayer.roleKey,

                isRevealed: game.isCurrentRevealed,

                word: revealInfo.word,

                categoryName: revealInfo.categoryName,

                spyHint: revealInfo.spyHint,

                coSpyNames: revealInfo.coSpyNames,

                onReveal: game.isCurrentRevealed ? null : notifier.reveal,

              ),

              const Spacer(),

              GradientButton(

                label: progress < aliveCount

                    ? 'word_reveal.pass_to_next'.tr()

                    : 'word_reveal.start_timer'.tr(),

                gradientColors: const [

                  AppColors.primaryBlue,

                  AppColors.accentClassic,

                ],

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



/// نشانگر پیشرفت بازیکن — الگوی pill بالای صفحه

class _ProgressPill extends StatelessWidget {

  const _ProgressPill({required this.label});



  final String label;



  @override

  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

      decoration: BoxDecoration(

        color: AppColors.surface,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.cardBorder),

      ),

      child: Text(

        label,

        style: Theme.of(context).textTheme.labelLarge?.copyWith(

              color: AppColors.textSecondary,

              fontWeight: FontWeight.w600,

            ),

      ),

    );

  }

}


