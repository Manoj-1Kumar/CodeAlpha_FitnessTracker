import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/validators.dart';
import '../models/user_goal.dart';
import '../services/goal_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final heightController = TextEditingController(text: "175");
  final weightController = TextEditingController(text: "70");

  final calorieGoalController = TextEditingController();
  final stepGoalController = TextEditingController();
  final workoutGoalController = TextEditingController();
  final waterGoalController = TextEditingController();

  double? bmiResult;
  String bmiCategory = "";
  Color bmiColor = Colors.green;

  UserGoal userGoal = UserGoal(
    calorieGoal: 2000,
    stepGoal: 10000,
    workoutGoal: 60,
    waterGoal: 2500,
  );

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGoals();
    calculateBMI();
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    calorieGoalController.dispose();
    stepGoalController.dispose();
    workoutGoalController.dispose();
    waterGoalController.dispose();
    super.dispose();
  }

  Future<void> loadGoals() async {
    final goal = await GoalService.getGoals();
    if (mounted) {
      setState(() {
        userGoal = goal;
        calorieGoalController.text = goal.calorieGoal.toString();
        stepGoalController.text = goal.stepGoal.toString();
        workoutGoalController.text = goal.workoutGoal.toString();
        waterGoalController.text = goal.waterGoal.toString();
        isLoading = false;
      });
    }
  }

  void calculateBMI() {
    final h = double.tryParse(heightController.text.trim());
    final w = double.tryParse(weightController.text.trim());

    if (h != null && w != null && h > 0) {
      final hMeters = h / 100;
      final bmi = w / (hMeters * hMeters);

      String cat = "Normal weight";
      Color col = AppColors.primary;

      if (bmi < 18.5) {
        cat = "Underweight";
        col = Colors.blue;
      } else if (bmi >= 18.5 && bmi < 25) {
        cat = "Normal weight";
        col = AppColors.primary;
      } else if (bmi >= 25 && bmi < 30) {
        cat = "Overweight";
        col = Colors.orange;
      } else {
        cat = "Obese";
        col = Colors.red;
      }

      setState(() {
        bmiResult = bmi;
        bmiCategory = cat;
        bmiColor = col;
      });
    }
  }

  Future<void> saveGoals() async {
    final cal = int.tryParse(calorieGoalController.text.trim()) ?? userGoal.calorieGoal;
    final stp = int.tryParse(stepGoalController.text.trim()) ?? userGoal.stepGoal;
    final wrk = int.tryParse(workoutGoalController.text.trim()) ?? userGoal.workoutGoal;
    final wtr = int.tryParse(waterGoalController.text.trim()) ?? userGoal.waterGoal;

    final updated = UserGoal(
      id: userGoal.id,
      calorieGoal: cal,
      stepGoal: stp,
      workoutGoal: wrk,
      waterGoal: wtr,
    );

    await GoalService.updateGoals(updated);

    if (mounted) {
      setState(() => userGoal = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fitness goals updated successfully! 🎯"),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile & Health",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // User Avatar Header
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fitness Enthusiast",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Level: Daily Active Member 🌟",
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // BMI Calculator Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.monitor_weight_outlined, color: AppColors.primary),
                              SizedBox(width: 10),
                              Text(
                                "BMI Calculator",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: heightController,
                                  label: "Height (cm)",
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.height,
                                  validator: Validators.validateHeight,
                                  onChanged: (_) => calculateBMI(),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: CustomTextField(
                                  controller: weightController,
                                  label: "Weight (kg)",
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.fitness_center,
                                  validator: Validators.validateWeight,
                                  onChanged: (_) => calculateBMI(),
                                ),
                              ),
                            ],
                          ),
                          if (bmiResult != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: bmiColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: bmiColor.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "BMI: ${bmiResult!.toStringAsFixed(1)}",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: bmiColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        bmiCategory,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: bmiColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    bmiResult! >= 18.5 && bmiResult! < 25
                                        ? Icons.check_circle
                                        : Icons.info,
                                    color: bmiColor,
                                    size: 36,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Goal Settings Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.flag_outlined, color: AppColors.primary),
                              SizedBox(width: 10),
                              Text(
                                "Daily Target Goals",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            controller: calorieGoalController,
                            label: "Calorie Goal (kcal)",
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.local_fire_department,
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            controller: stepGoalController,
                            label: "Step Goal (steps)",
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.directions_walk,
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            controller: workoutGoalController,
                            label: "Workout Goal (mins)",
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.timer,
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            controller: waterGoalController,
                            label: "Water Intake Goal (ml)",
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.water_drop,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: "Save Goals",
                            icon: Icons.save,
                            onPressed: saveGoals,
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