class Activity {
  final int? id;
  final String exercise;
  final int duration;
  final int calories;
  final int steps;
  final String date;

  Activity({
    this.id,
    required this.exercise,
    required this.duration,
    required this.calories,
    required this.steps,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise': exercise,
      'duration': duration,
      'calories': calories,
      'steps': steps,
      'date': date,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      exercise: map['exercise'],
      duration: map['duration'],
      calories: map['calories'],
      steps: map['steps'],
      date: map['date'],
    );
  }
}