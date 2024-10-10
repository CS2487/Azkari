import 'package:flutter/material.dart';

class EqualButtonsRow extends StatelessWidget {
  final List<Widget> children;
  const EqualButtonsRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final spaced = children
        .map((w) => Expanded(child: SizedBox(height: 56, child: w)))
        .toList();

    return Row(
      children: [
        for (int i = 0; i < spaced.length; i++) ...[
          if (i != 0) const SizedBox(width: 12),
          spaced[i],
        ]
      ],
    );
  }
}
