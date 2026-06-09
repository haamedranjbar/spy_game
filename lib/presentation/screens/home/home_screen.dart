import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';

/// صفحه اصلی — placeholder تا پیاده‌سازی کامل home
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.visibility_off,
                size: 80,
                color: AppColors.accentDefault.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 24),
              Text(
                'app.name'.tr(),
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'home.subtitle'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              GradientButton(
                label: 'home.start_game'.tr(),
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  // ناوبری به categories در فاز بعدی
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
