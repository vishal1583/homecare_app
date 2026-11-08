import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/date_time_extension.dart';

class DateScreen extends StatefulWidget {
  final Function(String) updateSelectedDate;

  const DateScreen({super.key, required this.updateSelectedDate});

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  String? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted) return;

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate.formatDate();
      });
      widget.updateSelectedDate(selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _selectDate(context),
      icon: const Icon(Icons.calendar_today_outlined, size: 18),
      label: Text(selectedDate ?? 'Choose date'),
    );
  }
}
