import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// کارت نمایش نقش بازیکن در word_reveal
class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.roleKey,
    required this.isRevealed,
    this.word,
    this.onReveal,
    this.accentColor = AppColors.accentDefault,
  });

  /// کلید ترجمه نقش، مثلاً role.citizen
  final String roleKey;
  final bool isRevealed;
  final String? word;
  final VoidCallback? onReveal;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: accentColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRevealed ? Icons.visibility : Icons.visibility_off,
            color: accentColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          if (isRevealed) ...[
            Text(
              roleKey.tr(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            if (word != null) ...[
              const SizedBox(height: 12),
              Text(
                'role.your_word'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                word!,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ] else ...[
            Text(
              'role.tap_to_reveal'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (onReveal != null) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onReveal,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentColor),
                  ),
                  child: Text(
                    'role.reveal'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
