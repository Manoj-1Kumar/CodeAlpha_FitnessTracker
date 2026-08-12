import '../database/database_helper.dart';
import '../models/activity.dart';
import 'water_service.dart';

class StatsService {
  static Future<List<Activity>> getActivities() async {
    return await DatabaseHelper.instance.getActivities();
  }

  static Future<List<int>> weeklyCalories() async {
    final activities = await getActivities();
    final result = List.filled(7, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final activity in activities) {
      try {
        final dateParsed = DateTime.parse(activity.date);
        final date = DateTime(dateParsed.year, dateParsed.month, dateParsed.day);
        final difference = today.difference(date).inDays;

        if (difference >= 0 && difference < 7) {
          result[6 - difference] += activity.calories;
        }
      } catch (_) {}
    }

    return result;
  }

  static Future<List<int>> weeklySteps() async {
    final activities = await getActivities();
    final result = List.filled(7, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final activity in activities) {
      try {
        final dateParsed = DateTime.parse(activity.date);
        final date = DateTime(dateParsed.year, dateParsed.month, dateParsed.day);
        final difference = today.difference(date).inDays;

        if (difference >= 0 && difference < 7) {
          result[6 - difference] += activity.steps;
        }
      } catch (_) {}
    }

    return result;
  }

  static Future<List<int>> weeklyWorkout() async {
    final activities = await getActivities();
    final result = List.filled(7, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final activity in activities) {
      try {
        final dateParsed = DateTime.parse(activity.date);
        final date = DateTime(dateParsed.year, dateParsed.month, dateParsed.day);
        final difference = today.difference(date).inDays;

        if (difference >= 0 && difference < 7) {
          result[6 - difference] += activity.duration;
        }
      } catch (_) {}
    }

    return result;
  }

  static Future<List<int>> weeklyWater() async {
    return await WaterService.weeklyWater();
  }

  static Future<Map<String, String>> getWeeklyTotals() async {
    final caloriesList = await weeklyCalories();
    final stepsList = await weeklySteps();
    final workoutList = await weeklyWorkout();

    final totalCalories = caloriesList.reduce((a, b) => a + b);
    final totalSteps = stepsList.reduce((a, b) => a + b);
    final totalWorkoutMins = workoutList.reduce((a, b) => a + b);

    final stepsFormatted = totalSteps >= 1000
        ? "${(totalSteps / 1000).toStringAsFixed(1)}K"
        : "$totalSteps";

    final workoutFormatted = totalWorkoutMins >= 60
        ? "${(totalWorkoutMins / 60).toStringAsFixed(1)}h"
        : "${totalWorkoutMins}m";

    return {
      'calories': "$totalCalories",
      'steps': stepsFormatted,
      'workout': workoutFormatted,
    };
  }
}