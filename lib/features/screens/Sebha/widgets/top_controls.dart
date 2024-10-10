import 'package:azkar_application/features/screens/sebha/widgets/dhikr_item.dart';
import 'package:flutter/material.dart';

class TopControls extends StatefulWidget {
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
  State<TopControls> createState() => _TopControlsState();
}

class _TopControlsState extends State<TopControls> {
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _goalController = TextEditingController(text: widget.goal.toString());
  }

  @override
  void didUpdateWidget(covariant TopControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal != widget.goal) {
      _goalController.text = widget.goal.toString();
    }
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<DhikrItem>(
          value: widget.selectedDhikr,
          items: widget.adhkar
              .map((e) => DropdownMenuItem<DhikrItem>(
                    value: e,
                    child: Text(
                      e.text,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ))
              .toList(),
          onChanged: widget.onDhikrChanged,
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
                height: 60,
                child: TextFormField(
                  controller: _goalController,
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
                    final g = int.tryParse(v) ?? widget.goal;
                    widget.onGoalChanged(g);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 60,
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  final defaultGoal = widget.selectedDhikr?.defaultGoal ?? 33;
                  _goalController.text = defaultGoal.toString();
                  widget.onGoalChanged(defaultGoal);
                },
                child: const Text('الافتراضي'),
              ),
            )
          ],
        )
      ],
    );
  }
}
