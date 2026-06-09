import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// دکمه تأیید با نگه‌داشتن — جلوگیری از لمس تصادفی
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

class _HoldConfirmButtonState extends State<HoldConfirmButton> {
  Timer? _timer;
  double _progress = 0;
  bool _isHolding = false;

  @override
  void dispose() {
    _cancelHold();
    super.dispose();
  }

  void _cancelHold() {
    _timer?.cancel();
    _timer = null;
    if (_isHolding || _progress > 0) {
      setState(() {
        _isHolding = false;
        _progress = 0;
      });
    }
  }

  void _startHold() {
    _cancelHold();
    setState(() {
      _isHolding = true;
      _progress = 0;
    });

    final tickMs = 50;
    final totalMs = widget.holdDuration.inMilliseconds;
    var elapsed = 0;

    _timer = Timer.periodic(Duration(milliseconds: tickMs), (timer) {
      elapsed += tickMs;
      final nextProgress = (elapsed / totalMs).clamp(0.0, 1.0);
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _progress = nextProgress);

      if (elapsed >= totalMs) {
        timer.cancel();
        _timer = null;
        setState(() {
          _isHolding = false;
          _progress = 0;
        });
        widget.onConfirmed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Listener(
            onPointerDown: (_) => _startHold(),
            onPointerUp: (_) => _cancelHold(),
            onPointerCancel: (_) => _cancelHold(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors.first.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: LinearProgressIndicator(
                      value: _isHolding ? _progress : 0,
                      backgroundColor: Colors.transparent,
                      color: AppColors.textPrimary.withValues(alpha: 0.25),
                      minHeight: 52,
                    ),
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
