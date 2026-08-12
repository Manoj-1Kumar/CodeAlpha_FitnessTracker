import 'package:flutter/material.dart';

import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onDelete,
    this.onEdit,
  });

  IconData getExerciseIcon(String exercise) {
    final value = exercise.toLowerCase();

    if (value.contains("run")) {
      return Icons.directions_run;
    }

    if (value.contains("walk")) {
      return Icons.directions_walk;
    }

    if (value.contains("gym") ||
        value.contains("weight") ||
        value.contains("workout")) {
      return Icons.fitness_center;
    }

    if (value.contains("cycle") ||
        value.contains("bike")) {
      return Icons.pedal_bike;
    }

    if (value.contains("swim")) {
      return Icons.pool;
    }

    if (value.contains("yoga")) {
      return Icons.self_improvement;
    }

    return Icons.sports;
  }

  Color getColor(String exercise) {
    final value = exercise.toLowerCase();

    if (value.contains("run")) {
      return Colors.orange;
    }

    if (value.contains("walk")) {
      return Colors.green;
    }

    if (value.contains("gym")) {
      return Colors.red;
    }

    if (value.contains("cycle")) {
      return Colors.blue;
    }

    if (value.contains("swim")) {
      return Colors.cyan;
    }

    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor(activity.exercise);

    return Dismissible(
      key: ValueKey(activity.id),

      direction: DismissDirection.endToStart,

      onDismissed: (_) {
        onDelete();
      },

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),

        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),

        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
      ),

      child: Card(
        elevation: 5,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: color,
                width: 6,
              ),
            ),
          ),

          child: ListTile(
            contentPadding: const EdgeInsets.all(18),

            leading: CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.15),

              child: Icon(
                getExerciseIcon(activity.exercise),
                color: color,
              ),
            ),

            title: Text(
              activity.exercise,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      const Icon(
                        Icons.timer,
                        size: 18,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 6),

                      Text("${activity.duration} min"),

                      const SizedBox(width: 15),

                      const Icon(
                        Icons.local_fire_department,
                        size: 18,
                        color: Colors.deepOrange,
                      ),

                      const SizedBox(width: 6),

                      Text("${activity.calories} kcal"),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [

                      const Icon(
                        Icons.directions_walk,
                        size: 18,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 6),

                      Text("${activity.steps} steps"),
                    ],
                  ),
                ],
              ),
            ),

            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "edit") {
                  onEdit?.call();
                }

                if (value == "delete") {
                  onDelete();
                }
              },

              itemBuilder: (_) => const [

                PopupMenuItem(
                  value: "edit",
                  child: Row(
                    children: [

                      Icon(Icons.edit),

                      SizedBox(width: 10),

                      Text("Edit"),
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children: [

                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),

                      SizedBox(width: 10),

                      Text("Delete"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}