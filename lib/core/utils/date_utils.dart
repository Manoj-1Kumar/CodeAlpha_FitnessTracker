import 'package:intl/intl.dart';

class AppDateUtils {
  /// Format date to 'yyyy-MM-dd'
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format date to display format e.g. 'Aug 06, 2026'
  static String formatDisplayDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  /// Format time to '10:30 AM'
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  /// Check if date string matches today
  static bool isToday(String dateStr) {
    final today = formatDate(DateTime.now());
    return dateStr == today;
  }

  /// Get day of week name ('Mon', 'Tue', etc.)
  static String getWeekdayShort(DateTime date) {
    return DateFormat('E').format(date);
  }

  /// Get list of past 7 dates as 'yyyy-MM-dd' strings, ordered from 6 days ago to today
  static List<String> getPast7Days() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return formatDate(day);
    });
  }

  /// Get list of past 7 weekday abbreviations ('M', 'T', 'W', etc.)
  static List<String> getPast7DayLabels() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return DateFormat('E').format(day).substring(0, 1);
    });
  }
}
