import 'package:flutter/material.dart';

class CircularCounter extends StatefulWidget {
  final double progress;
  final int count;
  final int goal;
  final Color primary;
  final Color surface;
  final Color shadow;
  final Color onSurfaceVariant;
  // تم تغيير التسمية ليتناسب مع الفصل
  final VoidCallback? onIncrementRequested;
  final Future<void> Function()? onHapticRequested;

  const CircularCounter({
    super.key,
    required this.progress,
    required this.count,
    required this.goal,
    required this.primary,
    required this.surface,
    required this.shadow,
    required this.onSurfaceVariant,
    this.onIncrementRequested,
    this.onHapticRequested,
  });

  @override
  State<CircularCounter> createState() => _CircularCounterState();
}

class _CircularCounterState extends State<CircularCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
    lowerBound: 0.0,
    upperBound: 0.12,
  );

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _playPulse() async {
    try {
      await _pulseController.forward();
    } finally {
      if (mounted) _pulseController.reverse();
    }
  }

  Future<void> _handleTap() async {
    // نطلب الزيادة من الـ Parent
    widget.onIncrementRequested?.call();
    await _playPulse(); // نبض الدائرة
    // نطلب الهزاز من الـ Parent
    if (widget.onHapticRequested != null) await widget.onHapticRequested!();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.7;
    final scale = 1.0 + _pulseController.value;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: widget.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.shadow.withOpacity(0.12),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: widget.onSurfaceVariant.withOpacity(0.2)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size * 0.86,
                height: size * 0.86,
                child: CircularProgressIndicator(
                  value: widget.progress,
                  strokeWidth: 10,
                  color: widget.primary,
                  backgroundColor: widget.onSurfaceVariant.withOpacity(0.12),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.count} / ${widget.goal}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.primary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.progress >= 1.0 ? 'تم' : 'واصل',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
