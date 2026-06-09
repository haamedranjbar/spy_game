import 'dart:math' show pi;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/data/models/player_role.dart';

/// ارتفاع ثابت همه کارت‌ها — تغییر ارتفاع قبل از چرخش نقش را لو می‌دهد
const double kRoleCardHeight = 420;

const Duration _flipDuration = Duration(milliseconds: 380);

const List<Color> _citizenGradient = [
  AppColors.primaryBlue,
  AppColors.accentDefault,
];

const List<Color> _spyGradient = [
  AppColors.primaryRed,
  AppColors.accentDanger,
];

const List<Color> _infiltratorGradient = [
  AppColors.accentPremium,
  AppColors.primaryRed,
];

/// کارت نمایش نقش با انیمیشن چرخش — الهام از الگوی اسکن و هویت مخفی
class RoleCard extends StatefulWidget {
  const RoleCard({
    super.key,
    required this.role,
    required this.roleKey,
    required this.isRevealed,
    this.word,
    this.categoryName,
    this.spyHint,
    this.coSpyNames = const [],
    this.onReveal,
    this.height = kRoleCardHeight,
  });

  final GameRole role;
  final String roleKey;
  final bool isRevealed;
  final String? word;
  final String? categoryName;
  final String? spyHint;
  final List<String> coSpyNames;
  final VoidCallback? onReveal;
  final double height;

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: _flipDuration,
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeOutCubic,
    );
    if (widget.isRevealed) {
      _flipController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant RoleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed && !oldWidget.isRevealed && !_isFlipping) {
      _flipController.forward();
    }
    if (!widget.isRevealed && oldWidget.isRevealed) {
      _flipController.reset();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isRevealed || widget.onReveal == null || _isFlipping) return;

    _isFlipping = true;
    _flipController.forward(from: 0).then((_) {
      if (!mounted) return;
      widget.onReveal?.call();
      _isFlipping = false;
    });
  }

  List<Color> get _roleGradient => switch (widget.role) {
        GameRole.citizen => _citizenGradient,
        GameRole.spy => _spyGradient,
        GameRole.infiltrator => _infiltratorGradient,
      };

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: GestureDetector(
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * pi;
                // کمی بعد از نیمه چرخش پشت کارت نمایش داده می‌شود
                final showFront = _flipAnimation.value < 0.48;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: showFront
                      ? const _CardFace(child: _FrontContent())
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: _CardFace(
                            gradient: _roleGradient,
                            child: _BackContent(
                              role: widget.role,
                              roleKey: widget.roleKey,
                              word: widget.word,
                              categoryName: widget.categoryName,
                              spyHint: widget.spyHint,
                              coSpyNames: widget.coSpyNames,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.child,
    this.gradient,
  });

  final Widget child;
  final List<Color>? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(28),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradient!,
              )
            : null,
        color: gradient == null ? AppColors.surfaceLight : null,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// روی کارت — خنثی و یکسان برای همه نقش‌ها
class _FrontContent extends StatelessWidget {
  const _FrontContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.35),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.fingerprint,
            color: AppColors.primaryBlue,
            size: 64,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'role.touch_to_scan'.tr(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// پشت کارت — محتوای نقش پس از چرخش
class _BackContent extends StatelessWidget {
  const _BackContent({
    required this.role,
    required this.roleKey,
    this.word,
    this.categoryName,
    this.spyHint,
    this.coSpyNames = const [],
  });

  final GameRole role;
  final String roleKey;
  final String? word;
  final String? categoryName;
  final String? spyHint;
  final List<String> coSpyNames;

  @override
  Widget build(BuildContext context) {
    if (role == GameRole.spy) {
      return _SpyBackContent(
        roleKey: roleKey,
        categoryName: categoryName,
        spyHint: spyHint,
        coSpyNames: coSpyNames,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _RoleIconBadge(role: role),
                const SizedBox(height: 20),
                if (word != null) ...[
                  Text(
                    'role.secret_word_label'.tr(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.75),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    word!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// چیدمان اختصاصی کارت جاسوس
class _SpyBackContent extends StatelessWidget {
  const _SpyBackContent({
    required this.roleKey,
    this.categoryName,
    this.spyHint,
    this.coSpyNames = const [],
  });

  final String roleKey;
  final String? categoryName;
  final String? spyHint;
  final List<String> coSpyNames;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: _RoleIconBadge(role: GameRole.spy)),
                const SizedBox(height: 16),
                Text(
                  'role.you_are_role'.tr(args: [roleKey.tr()]),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                  textAlign: TextAlign.center,
                ),
                if (categoryName != null) ...[
                  const SizedBox(height: 16),
                  _SpyInfoBox(
                    label: 'role.category'.tr(),
                    value: categoryName!,
                  ),
                ],
                if (spyHint != null) ...[
                  const SizedBox(height: 10),
                  _SpyInfoBox(
                    label: 'role.spy_hint'.tr(),
                    value: spyHint!,
                    emphasizeValue: true,
                  ),
                ],
                if (coSpyNames.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _CoSpyChipRow(names: coSpyNames),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _SpyWarningBox(),
      ],
    );
  }
}

/// کادر اطلاعات دسته یا راهنما در کارت جاسوس
class _SpyInfoBox extends StatelessWidget {
  const _SpyInfoBox({
    required this.label,
    required this.value,
    this.emphasizeValue = false,
  });

  final String label;
  final String value;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: emphasizeValue
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    )
                : Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// هشدار تیره پایین کارت جاسوس
class _SpyWarningBox extends StatelessWidget {
  const _SpyWarningBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.9),
        ),
      ),
      child: Text(
        'role.dont_reveal'.tr(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.92),
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _RoleIconBadge extends StatelessWidget {
  const _RoleIconBadge({required this.role});

  final GameRole role;

  @override
  Widget build(BuildContext context) {
    final icon = switch (role) {
      GameRole.citizen => Icons.sentiment_satisfied_alt_outlined,
      GameRole.spy => Icons.dangerous_outlined,
      GameRole.infiltrator => Icons.theater_comedy_outlined,
    };

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textPrimary.withValues(alpha: 0.12),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.25),
        ),
      ),
      child: Icon(
        icon,
        color: AppColors.textPrimary,
        size: 36,
      ),
    );
  }
}

/// نمایش اسامی جاسوس‌های دیگر به صورت chip در یک خط
class _CoSpyChipRow extends StatelessWidget {
  const _CoSpyChipRow({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'role.other_spies'.tr(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.75),
                letterSpacing: 1,
              ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: names.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.textPrimary.withValues(alpha: 0.28),
                  ),
                ),
                child: Text(
                  names[index],
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
