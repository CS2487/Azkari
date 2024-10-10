import 'package:flutter/material.dart';

class CircularCounter extends StatelessWidget {
  final double progress;
  final int count;
  final int goal;
  final double pulse;
  final Color primary;
  final Color surface;
  final Color shadow;
  final Color onSurfaceVariant;

  const CircularCounter({
    super.key,
    required this.progress,
    required this.count,
    required this.goal,
    required this.pulse,
    required this.primary,
    required this.surface,
    required this.shadow,
    required this.onSurfaceVariant,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.7;
    final scale = 1.0 + pulse;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadow.withOpacity(0.12),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: onSurfaceVariant.withOpacity(0.2)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size * 0.86,
              height: size * 0.86,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                color: primary,
                backgroundColor: onSurfaceVariant.withOpacity(0.12),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$count / $goal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  progress >= 1.0 ? 'تم' : 'واصل',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
