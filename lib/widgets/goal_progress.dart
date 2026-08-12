import 'package:flutter/material.dart';

class GoalProgress extends StatelessWidget {
  final int calories;
  final int calorieGoal;

  final int steps;
  final int stepGoal;

  final int workout;
  final int workoutGoal;

  final int? water;
  final int? waterGoal;

  const GoalProgress({
    super.key,
    required this.calories,
    required this.calorieGoal,
    required this.steps,
    required this.stepGoal,
    required this.workout,
    required this.workoutGoal,
    this.water,
    this.waterGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Goals",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _GoalTile(
              icon: Icons.local_fire_department,
              color: Colors.deepOrange,
              title: "Calories",
              current: calories,
              goal: calorieGoal,
              unit: "kcal",
            ),
            const SizedBox(height: 18),
            _GoalTile(
              icon: Icons.directions_walk,
              color: Colors.green,
              title: "Steps",
              current: steps,
              goal: stepGoal,
              unit: "steps",
            ),
            const SizedBox(height: 18),
            _GoalTile(
              icon: Icons.timer,
              color: Colors.blue,
              title: "Workout",
              current: workout,
              goal: workoutGoal,
              unit: "min",
            ),
            if (water != null && waterGoal != null) ...[
              const SizedBox(height: 18),
              _GoalTile(
                icon: Icons.local_drink,
                color: Colors.cyan,
                title: "Water Intake",
                current: water!,
                goal: waterGoal!,
                unit: "ml",
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final int current;
  final int goal;
  final String unit;

  const _GoalTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.current,
    required this.goal,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (goal > 0) ? (current / goal).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              "$current / $goal $unit",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0, end: progress),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                color: color,
                backgroundColor: Colors.grey.shade300,
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "${(progress * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}