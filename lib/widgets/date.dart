import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
      widget.updateSelectedDate(selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   selectedDate != null
        //       ? "Selected Date: $selectedDate"
        //       : "No date selected",
        //   style: const TextStyle(fontSize: 18),
        // ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _selectDate(context);
          },
          child: const Icon(Icons.edit_calendar),
        ),
      ],
    );
  }
}
