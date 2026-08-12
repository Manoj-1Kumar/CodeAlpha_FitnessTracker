class UserGoal {
  final int? id;
  final int calorieGoal;
  final int stepGoal;
  final int workoutGoal; // in minutes
  final int waterGoal; // in ml

  UserGoal({
    this.id,
    required this.calorieGoal,
    required this.stepGoal,
    required this.workoutGoal,
    required this.waterGoal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? 1,
      'calorieGoal': calorieGoal,
      'stepGoal': stepGoal,
      'workoutGoal': workoutGoal,
      'waterGoal': waterGoal,
    };
  }

  factory UserGoal.fromMap(Map<String, dynamic> map) {
    return UserGoal(
      id: map['id'],
      calorieGoal: map['calorieGoal'] ?? 2000,
      stepGoal: map['stepGoal'] ?? 10000,
      workoutGoal: map['workoutGoal'] ?? 60,
      waterGoal: map['waterGoal'] ?? 2500,
    );
  }

  UserGoal copyWith({
    int? id,
    int? calorieGoal,
    int? stepGoal,
    int? workoutGoal,
    int? waterGoal,
  }) {
    return UserGoal(
      id: id ?? this.id,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      stepGoal: stepGoal ?? this.stepGoal,
      workoutGoal: workoutGoal ?? this.workoutGoal,
      waterGoal: waterGoal ?? this.waterGoal,
    );
  }
}
