import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';

class ProviderDetailRow extends StatelessWidget {
  const ProviderDetailRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.muted, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.theme.textTheme.bodySmall),
                const SizedBox(height: 3),
                SelectableText(value, style: context.theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
