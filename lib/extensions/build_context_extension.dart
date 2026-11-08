import 'package:flutter/material.dart';

/// Accesses the Flutter services closest to this context.
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  NavigatorState get navigator => Navigator.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Returns true only when the user explicitly confirms the action.
  Future<bool> confirmAction({
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: this,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => dialogContext.navigator.pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: destructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: dialogContext.theme.colorScheme.error,
                    foregroundColor: dialogContext.theme.colorScheme.onError,
                  )
                : null,
            onPressed: () => dialogContext.navigator.pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
