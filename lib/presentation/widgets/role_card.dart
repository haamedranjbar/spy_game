import 'dart:math' show pi;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/data/models/player_role.dart';

/// ارتفاع ثابت همه کارت‌ها — تغییر ارتفاع قبل از چرخش نقش را لو می‌دهد
const double kRoleCardHeight = 420;

const Duration _flipDuration = Duration(milliseconds: 380);

const List<Color> _spyGradient = [
  AppColors.primaryRed,
  AppColors.accentDanger,
];

const List<Color> _infiltratorGradient = [
  AppColors.accentPremium,
  AppColors.primaryRed,
];

const List<Color> _detectiveGradient = [
  AppColors.primaryBlue,
  AppColors.accentDefault,
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
        GameRole.citizen => AppColors.citizenCardGradient,
        GameRole.spy => _spyGradient,
        GameRole.detective => _detectiveGradient,
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
                            padding: widget.role == GameRole.citizen ||
                                    widget.role == GameRole.detective
                                ? EdgeInsets.zero
                                : const EdgeInsets.all(28),
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
    this.padding = const EdgeInsets.all(28),
  });

  final Widget child;
  final List<Color>? gradient;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: padding,
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

    if (role == GameRole.citizen) {
      return _CitizenBackContent(word: word);
    }

    if (role == GameRole.detective) {
      return _DetectiveBackContent(word: word, roleKey: roleKey);
    }

    if (role == GameRole.infiltrator) {
      return _InfiltratorBackContent(
        roleKey: roleKey,
        word: word,
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

/// چیدمان اختصاصی کارت شهروند — گرادیان آبی-بنفش با هاله و کلمه بزرگ
class _CitizenBackContent extends StatelessWidget {
  const _CitizenBackContent({this.word});

  final String? word;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // هاله نیم‌دایره‌ای در نیمه بالایی کارت
            Positioned(
              top: -constraints.maxHeight * 0.18,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: constraints.maxWidth * 1.1,
                  height: constraints.maxHeight * 0.62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.citizenCardGlow.withValues(alpha: 0.38),
                        AppColors.citizenCardGlow.withValues(alpha: 0.12),
                        AppColors.citizenCardGlow.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.45, 1],
                    ),
                  ),
                ),
              ),
            ),
            // محتوای مرکزی — آیکون در ثلث بالا، کلمه در میانه پایین
            Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.16),
                const _CitizenIconBadge(),
                SizedBox(height: constraints.maxHeight * 0.14),
                if (word != null) ...[
                  Text(
                    'role.secret_word_label'.tr().toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.62),
                          letterSpacing: 2.2,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      word!,
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

/// چیدمان اختصاصی کارت کاراگاه — کلمه + یادآوری بازجویی
class _DetectiveBackContent extends StatelessWidget {
  const _DetectiveBackContent({
    required this.roleKey,
    this.word,
  });

  final String roleKey;
  final String? word;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: -constraints.maxHeight * 0.18,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: constraints.maxWidth * 1.1,
                  height: constraints.maxHeight * 0.62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryBlue.withValues(alpha: 0.35),
                        AppColors.primaryBlue.withValues(alpha: 0.1),
                        AppColors.primaryBlue.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.45, 1],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.12),
                const _RoleIconBadge(role: GameRole.detective),
                const SizedBox(height: 12),
                Text(
                  'role.you_are_role'.tr(args: [roleKey.tr()]),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: constraints.maxHeight * 0.1),
                if (word != null) ...[
                  Text(
                    'role.secret_word_label'.tr().toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.62),
                          letterSpacing: 2.2,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      word!,
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    'role.detective_hint'.tr(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// آیکون لبخند شهروند — دایره تیره نیمه‌شفاف
class _CitizenIconBadge extends StatelessWidget {
  const _CitizenIconBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background.withValues(alpha: 0.38),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.sentiment_satisfied_alt_outlined,
        color: AppColors.textPrimary,
        size: 48,
      ),
    );
  }
}

/// چیدمان اختصاصی کارت نفوذی — کلمه + شناسایی جاسوس‌ها
class _InfiltratorBackContent extends StatelessWidget {
  const _InfiltratorBackContent({
    required this.roleKey,
    this.word,
    this.coSpyNames = const [],
  });

  final String roleKey;
  final String? word;
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
                const Center(
                  child: _RoleIconBadge(role: GameRole.infiltrator),
                ),
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
                if (word != null) ...[
                  const SizedBox(height: 16),
                  _SpyInfoBox(
                    label: 'role.secret_word_label'.tr(),
                    value: word!,
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
      GameRole.detective => Icons.search_outlined,
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
