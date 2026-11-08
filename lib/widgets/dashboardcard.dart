import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTapping});

  final IconData icon;
  final String title;
  final VoidCallback onTapping;

  static const _descriptions = {
    'My Profile': 'Your details, all in order.',
    'Available Services': 'Find the right person for the job.',
    'My Bookings': 'Keep track of every visit.',
    'View Bookings': 'Review your new requests.',
    'Accepted Work': 'See what is coming up next.',
    'Feedback': 'Hear from your customers.',
    'Logout': 'Sign out of your account.',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTapping,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: title == 'Available Services'
                        ? AppColors.accentSoft
                        : AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(icon,
                    color: title == 'Available Services'
                        ? AppColors.accent
                        : AppColors.primary),
              ),
              const SizedBox(height: 22),
              Text(title, style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(_descriptions[title] ?? 'Explore this section.'),
              const SizedBox(height: 18),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
