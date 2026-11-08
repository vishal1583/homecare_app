extension StringExtension on String {
  /// Capitalizes the first character, preserving the rest of the text.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
