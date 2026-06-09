import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/timer/timer_provider.dart';
import 'package:spy_game/presentation/widgets/hold_confirm_button.dart';
import 'package:spy_game/presentation/widgets/timer_widget.dart';

/// صفحه تایمر بحث
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = ref.read(gameProvider);
      ref.read(timerProvider.notifier).startIfNeeded(game.timerSeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final game = ref.watch(gameProvider);
    final notifier = ref.read(timerProvider.notifier);

    ref.listen(gameProvider, (previous, next) {
      if (next.phase == GamePhase.voting) {
        context.go(AppRoutes.voting);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('timer.discussion'.tr()),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'timer.round'.tr(args: [game.roundNumber.toString()]),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              TimerWidget(
                remainingSeconds: timerState.remainingSeconds,
                totalSeconds: timerState.totalSeconds,
                accentColor: AppColors.accentDefault,
              ),
              const SizedBox(height: 24),
              Text(
                'timer.hint'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              HoldConfirmButton(
                label: 'timer.end_early'.tr(),
                hint: 'timer.hold_end_early_hint'.tr(),
                holdDuration: const Duration(seconds: 2),
                icon: Icons.stop_circle_outlined,
                gradientColors: const [
                  AppColors.accentDanger,
                  AppColors.primaryRed,
                ],
                onConfirmed: () {
                  if (timerState.isRunning) {
                    notifier.endEarly();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
