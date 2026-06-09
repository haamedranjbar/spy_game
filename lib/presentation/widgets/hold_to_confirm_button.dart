import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';

/// دکمه نگه‌داشتن برای تأیید — جلوگیری از لمس تصادفی
class HoldToConfirmButton extends StatefulWidget {
  const HoldToConfirmButton({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.holdDuration = const Duration(seconds: 3),
    this.icon,
    this.color = AppColors.accentDanger,
    this.hint,
  });

  final String label;
  final VoidCallback? onConfirmed;
  final Duration holdDuration;
  final IconData? icon;
  final Color color;
  final String? hint;

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton> {
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
    if (widget.onConfirmed == null) return;
    setState(() {
      _isHolding = true;
      _progress = 0;
    });

    final tickMs = 50;
    final totalMs = widget.holdDuration.inMilliseconds;
    var elapsed = 0;

    _timer = Timer.periodic(Duration(milliseconds: tickMs), (timer) {
      elapsed += tickMs;
      final next = (elapsed / totalMs).clamp(0.0, 1.0);
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _progress = next);

      if (elapsed >= totalMs) {
        timer.cancel();
        _timer = null;
        setState(() {
          _isHolding = false;
          _progress = 0;
        });
        widget.onConfirmed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 52,
          child: Listener(
            onPointerDown: (_) => _startHold(),
            onPointerUp: (_) => _cancelHold(),
            onPointerCancel: (_) => _cancelHold(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHolding ? widget.color : AppColors.cardBorder,
                  width: _isHolding ? 2 : 1,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progress,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: widget.color,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: widget.color,
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
