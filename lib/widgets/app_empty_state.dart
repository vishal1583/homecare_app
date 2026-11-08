import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState(
      {super.key,
      required this.title,
      required this.message,
      this.icon = Icons.calendar_month_outlined});

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(icon, size: 32)),
              const SizedBox(height: 22),
              Text(title,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
