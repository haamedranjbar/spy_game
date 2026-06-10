import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// جلوگیری از خروج تصادفی — پرسش تأیید قبل از بستن اپ
class ExitConfirmScope extends StatelessWidget {
  const ExitConfirmScope({
    super.key,
    required this.child,
  });

  final Widget child;

  Future<void> _confirmExit(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('common.exit_title'.tr()),
        content: Text('common.exit_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'common.exit'.tr(),
              style: Theme.of(dialogContext).textTheme.labelLarge?.copyWith(
                    color: AppColors.accentDanger,
                  ),
            ),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _confirmExit(context);
      },
      child: child,
    );
  }
}
