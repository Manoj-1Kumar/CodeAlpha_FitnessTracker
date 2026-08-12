import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/validators.dart';
import '../database/database_helper.dart';
import '../models/activity.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  final exerciseController = TextEditingController(text: "Running");
  final durationController = TextEditingController(text: "30");
  final caloriesController = TextEditingController(text: "300");
  final stepsController = TextEditingController(text: "3500");

  String selectedCategory = "Running";
  bool isSaving = false;

  @override
  void dispose() {
    exerciseController.dispose();
    durationController.dispose();
    caloriesController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  void onCategorySelected(String name) {
    setState(() {
      selectedCategory = name;
      exerciseController.text = name;
      autoCalculateEstimate();
    });
  }

  void autoCalculateEstimate() {
    final mins = int.tryParse(durationController.text) ?? 0;
    final catMap = AppConstants.exerciseCategories.firstWhere(
      (e) => (e['name'] as String).toLowerCase().contains(selectedCategory.toLowerCase()),
      orElse: () => AppConstants.exerciseCategories[0],
    );

    final calPerMin = (catMap['calPerMin'] as int);
    final estCalories = mins * calPerMin;
    caloriesController.text = "$estCalories";

    if (selectedCategory == "Running" || selectedCategory == "Walking") {
      final estSteps = mins * (selectedCategory == "Running" ? 150 : 100);
      stepsController.text = "$estSteps";
    }
  }

  Future<void> saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final activity = Activity(
      exercise: exerciseController.text.trim(),
      duration: int.parse(durationController.text.trim()),
      calories: int.parse(caloriesController.text.trim()),
      steps: int.parse(stepsController.text.trim()),
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    await DatabaseHelper.instance.insert(activity);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Activity logged successfully! 💪"),
        duration: Duration(seconds: 1),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Activity Log",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Exercise Type",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Exercise Category Badges Grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.exerciseCategories.map((cat) {
                  final name = cat['name'] as String;
                  final icon = cat['icon'] as IconData;
                  final color = cat['color'] as Color;
                  final isSelected = selectedCategory == name;

                  return ChoiceChip(
                    avatar: Icon(
                      icon,
                      color: isSelected ? Colors.white : color,
                      size: 18,
                    ),
                    label: Text(name),
                    selected: isSelected,
                    selectedColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) => onCategorySelected(name),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              CustomTextField(
                controller: exerciseController,
                label: "Exercise Name",
                prefixIcon: Icons.fitness_center,
                validator: (val) => Validators.validateRequired(val, "exercise name"),
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: durationController,
                label: "Duration (minutes)",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.timer,
                validator: (val) => Validators.validatePositiveNumber(val, "duration"),
                onChanged: (_) => autoCalculateEstimate(),
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: caloriesController,
                label: "Calories Burned (kcal)",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.local_fire_department,
                validator: (val) => Validators.validatePositiveNumber(val, "calories"),
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: stepsController,
                label: "Steps Count",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.directions_walk,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter steps (0 if none)";
                  if (int.tryParse(val) == null || int.parse(val) < 0) {
                    return "Steps cannot be negative";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 35),

              CustomButton(
                text: "Save Activity",
                icon: Icons.save,
                isLoading: isSaving,
                onPressed: saveActivity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}