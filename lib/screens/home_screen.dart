import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/database_helper.dart';
import '../../models/activity.dart';
import '../../models/user_goal.dart';
import '../../services/goal_service.dart';
import '../../services/water_service.dart';

import '../../widgets/dashboard_header.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/goal_progress.dart';

import './add_activity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Activity> activities = [];

  int calories = 0;
  int steps = 0;
  int workoutMinutes = 0;
  int waterIntake = 0;

  UserGoal userGoal = UserGoal(
    calorieGoal: 2000,
    stepGoal: 10000,
    workoutGoal: 60,
    waterGoal: 2500,
  );

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final all = await DatabaseHelper.instance.getActivities();
    final goals = await GoalService.getGoals();
    final water = await WaterService.getTodayWaterTotal();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    activities = all.where((e) => e.date == today).toList();

    int calSum = 0;
    int stepSum = 0;
    int wrkSum = 0;

    for (final activity in activities) {
      calSum += activity.calories;
      stepSum += activity.steps;
      wrkSum += activity.duration;
    }

    if (mounted) {
      setState(() {
        calories = calSum;
        steps = stepSum;
        workoutMinutes = wrkSum;
        waterIntake = water;
        userGoal = goals;
      });
    }
  }

  Future<void> deleteActivity(int id) async {
    await DatabaseHelper.instance.delete(id);
    loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Activity",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddActivityScreen(),
            ),
          );
          loadDashboardData();
        },
      ),
      body: RefreshIndicator(
        onRefresh: loadDashboardData,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: DashboardHeader(),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(18),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Expanded(
                          child: CircularProgressCard(
                            title: "Calories",
                            value: "$calories kcal",
                            percent: userGoal.calorieGoal > 0
                                ? calories / userGoal.calorieGoal
                                : 0.0,
                            icon: Icons.local_fire_department,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CircularProgressCard(
                            title: "Steps",
                            value: "$steps",
                            percent: userGoal.stepGoal > 0
                                ? steps / userGoal.stepGoal
                                : 0.0,
                            icon: Icons.directions_walk,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CircularProgressCard(
                            title: "Workout",
                            value: "$workoutMinutes min",
                            percent: userGoal.workoutGoal > 0
                                ? workoutMinutes / userGoal.workoutGoal
                                : 0.0,
                            icon: Icons.timer,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CircularProgressCard(
                            title: "Water",
                            value: "$waterIntake ml",
                            percent: userGoal.waterGoal > 0
                                ? waterIntake / userGoal.waterGoal
                                : 0.0,
                            icon: Icons.water_drop,
                            color: Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    GoalProgress(
                      calories: calories,
                      calorieGoal: userGoal.calorieGoal,
                      steps: steps,
                      stepGoal: userGoal.stepGoal,
                      workout: workoutMinutes,
                      workoutGoal: userGoal.workoutGoal,
                      water: waterIntake,
                      waterGoal: userGoal.waterGoal,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Today's Activities",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (activities.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(35),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "No activities yet",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap the + button to add your first workout.",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ...activities.map(
                        (activity) => Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ActivityCard(
                            activity: activity,
                            onDelete: () => deleteActivity(activity.id!),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}