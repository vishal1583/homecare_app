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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   selectedTime != null
        //       ? "Selected Time: $selectedTime"
        //       : "No time selected",
        //   style: const TextStyle(fontSize: 18),
        // ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            _selectTime(context);
          },
          child: const Icon(Icons.schedule_rounded),
        ),
      ],
    );
  }
}
