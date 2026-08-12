import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/water_log.dart';

class WaterService {
  static Future<int> addWaterLog(int amount) async {
    final now = DateTime.now();
    final date = DateFormat('yyyy-MM-dd').format(now);
    final timestamp = DateFormat('hh:mm a').format(now);

    final log = WaterLog(
      amount: amount,
      date: date,
      timestamp: timestamp,
    );

    return await DatabaseHelper.instance.insertWaterLog(log);
  }

  static Future<List<WaterLog>> getTodayWaterLogs() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return await DatabaseHelper.instance.getWaterLogsByDate(today);
  }

  static Future<int> getTodayWaterTotal() async {
    final logs = await getTodayWaterLogs();
    int total = 0;
    for (final log in logs) {
      total += log.amount;
    }
    return total;
  }

  static Future<void> deleteWaterLog(int id) async {
    await DatabaseHelper.instance.deleteWaterLog(id);
  }

  static Future<List<int>> weeklyWater() async {
    final allLogs = await DatabaseHelper.instance.getAllWaterLogs();
    final result = List.filled(7, 0);
    final now = DateTime.now();

    for (final log in allLogs) {
      final date = DateTime.parse(log.date);
      final difference = now.difference(date).inDays;

      if (difference >= 0 && difference < 7) {
        result[6 - difference] += log.amount;
      }
    }

    return result;
  }
}
