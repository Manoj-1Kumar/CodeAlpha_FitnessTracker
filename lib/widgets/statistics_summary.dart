import 'package:flutter/material.dart';

class StatisticsSummary extends StatelessWidget {
  final List<int> caloriesData;
  final List<int> stepsData;
  final List<int> workoutData;

  const StatisticsSummary({
    super.key,
    this.caloriesData = const [0, 0, 0, 0, 0, 0, 0],
    this.stepsData = const [0, 0, 0, 0, 0, 0, 0],
    this.workoutData = const [0, 0, 0, 0, 0, 0, 0],
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories = caloriesData.fold<int>(0, (a, b) => a + b);
    final totalSteps = stepsData.fold<int>(0, (a, b) => a + b);
    final totalWorkout = workoutData.fold<int>(0, (a, b) => a + b);

    final stepsFormatted = totalSteps >= 1000
        ? "${(totalSteps / 1000).toStringAsFixed(1)}K"
        : "$totalSteps";

    final workoutFormatted = totalWorkout >= 60
        ? "${(totalWorkout / 60).toStringAsFixed(1)}h"
        : "${totalWorkout}m";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "7-Day Total Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  title: "Calories",
                  value: "$totalCalories",
                  unit: "kcal",
                  color: Colors.orange,
                  icon: Icons.local_fire_department,
                ),
                _StatItem(
                  title: "Steps",
                  value: stepsFormatted,
                  unit: "total",
                  color: Colors.green,
                  icon: Icons.directions_walk,
                ),
                _StatItem(
                  title: "Workout",
                  value: workoutFormatted,
                  unit: "time",
                  color: Colors.blue,
                  icon: Icons.timer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}