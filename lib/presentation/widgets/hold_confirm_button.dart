import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// دکمه تأیید با نگه‌داشتن — نوار پیشرفت تمام‌عرض
class HoldConfirmButton extends StatefulWidget {
  const HoldConfirmButton({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.holdDuration = const Duration(seconds: 3),
    this.icon,
    this.gradientColors = AppColors.gradientPurple,
    this.hint,
  });

  final String label;
  final String? hint;
  final VoidCallback onConfirmed;
  final Duration holdDuration;
  final IconData? icon;
  final List<Color> gradientColors;

  @override
  State<HoldConfirmButton> createState() => _HoldConfirmButtonState();
}

class _HoldConfirmButtonState extends State<HoldConfirmButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  bool _completed = false;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    _controller.addStatusListener(_onAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant HoldConfirmButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.holdDuration != widget.holdDuration) {
      _controller.duration = widget.holdDuration;
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      if (_isHolding) {
        setState(() => _isHolding = false);
      }
      return;
    }
    if (status != AnimationStatus.completed || _completed) return;
    _completed = true;
    _isHolding = false;
    HapticFeedback.mediumImpact();
    widget.onConfirmed();
    _controller.reset();
    _completed = false;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  void _startHold() {
    if (_controller.isAnimating &&
        _controller.status == AnimationStatus.reverse) {
      _controller.stop();
    }
    setState(() => _isHolding = true);
    HapticFeedback.selectionClick();
    _controller.forward(from: _controller.value);
  }

  void _cancelHold() {
    if (_controller.value <= 0 || _completed) {
      setState(() => _isHolding = false);
      return;
    }
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (_) => _startHold(),
            onPointerUp: (_) => _cancelHold(),
            onPointerCancel: (_) => _cancelHold(),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // مقدار پیشرفت باید داخل builder خوانده شود تا هر فریم به‌روز شود
                final progress = _progress.value;

                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: widget.gradientColors.first.withValues(
                          alpha: progress > 0 ? 0.45 : 0.3,
                        ),
                        blurRadius: progress > 0 ? 14 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.gradientColors,
                            ),
                          ),
                        ),
                        // نوار پیشرفت تمام‌ارتفاع — واضح روی گرادیان
                        if (progress > 0)
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 52,
                            backgroundColor: Colors.transparent,
                            color: AppColors.textPrimary.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.zero,
                          ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: AppColors.textPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.hint != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.hint!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
