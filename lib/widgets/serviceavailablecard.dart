import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/extensions/string_extension.dart';

class ServiceAvailableCard extends StatelessWidget {
  const ServiceAvailableCard(
      {super.key,
      required this.leading,
      required this.title,
      required this.subtitle,
      this.location = '',
      this.onPressed});

  final String leading;
  final String title;
  final String subtitle;
  final String location;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(leading,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title.capitalize(),
                          style: context.theme.textTheme.titleMedium),
                      if (location.trim().isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16, color: AppColors.muted),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: Text(location.capitalize(),
                                      style: context.theme.textTheme.bodySmall))
                            ]),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('SPECIALTIES',
                style: context.theme.textTheme.labelSmall
                    ?.copyWith(color: AppColors.muted)),
            const SizedBox(height: 8),
            Text(
                subtitle.trim().isEmpty
                    ? 'View this provider for more details.'
                    : subtitle.capitalize(),
                style: context.theme.textTheme.bodyLarge),
            const SizedBox(height: 22),
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: onPressed, child: const Text('View provider'))),
          ],
        ),
      ),
    );
  }
}
