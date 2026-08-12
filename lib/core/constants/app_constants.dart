import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Fitness Tracker";

  // Default User Goals
  static const int defaultCalorieGoal = 2000;
  static const int defaultStepGoal = 10000;
  static const int defaultWorkoutGoal = 60; // in minutes
  static const int defaultWaterGoal = 2500; // in ml

  // Exercise Categories with default colors and icons
  static const List<Map<String, dynamic>> exerciseCategories = [
    {
      'name': 'Running',
      'icon': Icons.directions_run,
      'color': Colors.orange,
      'calPerMin': 10,
    },
    {
      'name': 'Cycling',
      'icon': Icons.directions_bike,
      'color': Colors.blue,
      'calPerMin': 8,
    },
    {
      'name': 'Walking',
      'icon': Icons.directions_walk,
      'color': Colors.green,
      'calPerMin': 4,
    },
    {
      'name': 'Gym / Weightlifting',
      'icon': Icons.fitness_center,
      'color': Colors.purple,
      'calPerMin': 7,
    },
    {
      'name': 'Swimming',
      'icon': Icons.pool,
      'color': Colors.cyan,
      'calPerMin': 9,
    },
    {
      'name': 'Yoga / Stretching',
      'icon': Icons.self_improvement,
      'color': Colors.teal,
      'calPerMin': 3,
    },
    {
      'name': 'HIIT / Cardio',
      'icon': Icons.bolt,
      'color': Colors.red,
      'calPerMin': 12,
    },
  ];
}
