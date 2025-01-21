import 'package:flutter/material.dart';

import '../constants/my_colors.dart';

class ServiceAvailableCard extends StatelessWidget {
  const ServiceAvailableCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.onPressed,
  });

  final String leading;
  final String title;
  final String subtitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      color: vanillaShade, // Using vanillaShade as card background
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(
          leading,
          style: TextStyle(
            color: theme.iconTheme.color, // softBlue from the theme
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // Use bodyLarge for the title
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: theme.textTheme.bodySmall?.color, // Use bodySmall for subtitle
          ),
        ),
        trailing: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(theme.colorScheme.secondary), // accentOrange
            foregroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          ),
          child: const Text('Book'),
        ),
      ),
    );
  }
}
