import 'package:flutter/material.dart';
import '../services/stats_service.dart';
import '../widgets/weekly_calories_chart.dart';
import '../widgets/weekly_steps_chart.dart';
import '../widgets/weekly_workout_chart.dart';
import '../widgets/statistics_summary.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<int> caloriesData = [0, 0, 0, 0, 0, 0, 0];
  List<int> stepsData = [0, 0, 0, 0, 0, 0, 0];
  List<int> workoutData = [0, 0, 0, 0, 0, 0, 0];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    setState(() => isLoading = true);
    final cData = await StatsService.weeklyCalories();
    final sData = await StatsService.weeklySteps();
    final wData = await StatsService.weeklyWorkout();

    if (mounted) {
      setState(() {
        caloriesData = cData;
        stepsData = sData;
        workoutData = wData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistics & Analytics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadStats,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Weekly Overview",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    StatisticsSummary(
                      caloriesData: caloriesData,
                      stepsData: stepsData,
                      workoutData: workoutData,
                    ),
                    const SizedBox(height: 25),
                    WeeklyCaloriesChart(data: caloriesData),
                    const SizedBox(height: 20),
                    WeeklyStepsChart(data: stepsData),
                    const SizedBox(height: 20),
                    WeeklyWorkoutChart(data: workoutData),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
    );
  }
}