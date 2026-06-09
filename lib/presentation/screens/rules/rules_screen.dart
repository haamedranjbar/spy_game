import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// صفحه قوانین و راهنمای بازی
class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  static const List<String> _sectionKeys = [
    'rules.intro',
    'rules.roles_title',
    'rules.role_citizen',
    'rules.role_spy',
    'rules.role_detective',
    'rules.role_infiltrator',
    'rules.win_citizens',
    'rules.win_spies',
    'rules.flow_title',
    'rules.flow_steps',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('rules.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _sectionKeys.map((key) {
                  final isTitle = key.endsWith('_title');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      key.tr(),
                      style: isTitle
                          ? Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.accentDefault,
                                fontWeight: FontWeight.w700,
                              )
                          : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                              ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
