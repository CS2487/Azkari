import 'package:flutter/material.dart';

class PrimaryBigButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PrimaryBigButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
