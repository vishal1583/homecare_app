import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Formats a date without changing its time zone.
  String formatDate({String pattern = 'dd-MM-yyyy', String? locale}) {
    return DateFormat(pattern, locale).format(this);
  }
}
