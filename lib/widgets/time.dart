import 'package:flutter/material.dart';

class TimeScreen extends StatefulWidget {
  final Function(String) updateSelectedTime;

  const TimeScreen({super.key, required this.updateSelectedTime});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  String? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((TimeOfDay? time) {
      if (!mounted || !context.mounted) return;
      if (time != null) {
        setState(() {
          selectedTime = time.format(context);
        });
        widget.updateSelectedTime(selectedTime!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _selectTime(context),
      icon: const Icon(Icons.schedule_rounded, size: 18),
      label: Text(selectedTime ?? 'Choose time'),
    );
  }
}
