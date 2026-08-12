import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codealpha_fitness_tracker/widgets/custom_button.dart';
import 'package:codealpha_fitness_tracker/widgets/custom_textfield.dart';
import 'package:codealpha_fitness_tracker/widgets/dashboard_header.dart';
import 'package:codealpha_fitness_tracker/widgets/goal_progress.dart';

void main() {
  testWidgets('DashboardHeader renders greeting correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardHeader(),
        ),
      ),
    );

    expect(find.text("Today's Progress"), findsOneWidget);
    expect(find.text("Let's achieve your fitness goals today!"), findsOneWidget);
  });

  testWidgets('CustomButton responds to tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: "Save Activity",
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text("Save Activity"), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(tapped, isTrue);
  });

  testWidgets('CustomTextField displays label and hints', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            label: "Exercise Name",
            prefixIcon: Icons.fitness_center,
          ),
        ),
      ),
    );

    expect(find.text("Exercise Name"), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center), findsOneWidget);
  });

  testWidgets('GoalProgress renders progress tiles', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GoalProgress(
            calories: 500,
            calorieGoal: 2000,
            steps: 5000,
            stepGoal: 10000,
            workout: 30,
            workoutGoal: 60,
            water: 1250,
            waterGoal: 2500,
          ),
        ),
      ),
    );

    expect(find.text("Today's Goals"), findsOneWidget);
    expect(find.text("Calories"), findsOneWidget);
    expect(find.text("Steps"), findsOneWidget);
    expect(find.text("Workout"), findsOneWidget);
    expect(find.text("Water Intake"), findsOneWidget);
  });
}
