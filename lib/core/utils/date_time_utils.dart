import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String formatDayNumber(DateTime date) {
    return DateFormat('d').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM y').format(date);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static List<DateTime> getWeekDates(DateTime anchor) {
    // Return Monday to Sunday of the anchor date's week
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }
}
