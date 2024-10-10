import 'package:azkar_application/features/screens/Sebha/widgets/dhikr_item.dart';
import 'package:flutter/material.dart';

class TopControls extends StatelessWidget {
  final List<DhikrItem> adhkar;
  final DhikrItem? selectedDhikr;
  final int goal;
  final ValueChanged<DhikrItem?> onDhikrChanged;
  final ValueChanged<int> onGoalChanged;

  const TopControls({
    super.key,
    required this.adhkar,
    required this.selectedDhikr,
    required this.goal,
    required this.onDhikrChanged,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<DhikrItem>(
          value: selectedDhikr,
          items: adhkar
              .map((e) => DropdownMenuItem<DhikrItem>(
                    value: e,
                    child: Text(
                      e.text,
                      style: const TextStyle(fontSize: 16), // حجم مناسب
                      textAlign: TextAlign.right, // لمحاذاة النص العربي
                    ),
                  ))
              .toList(),
          onChanged: onDhikrChanged,
          decoration: InputDecoration(
            labelText: 'اختر الذِكر',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            isDense: false,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 60, // نفس ارتفاع الزر
                child: TextFormField(
                  initialValue: goal.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'العدد المستهدف',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (v) {
                    final g = int.tryParse(v) ?? goal;
                    onGoalChanged(g);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 60, // نفس ارتفاع TextFormField
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.grey.shade400), // خط الحواف
                  ),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () =>
                    onGoalChanged(selectedDhikr?.defaultGoal ?? 33),
                child: const Text('الافتراضي'),
              ),
            )
          ],
        )
      ],
    );
  }
}
