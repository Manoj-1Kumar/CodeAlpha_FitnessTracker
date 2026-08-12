import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../core/constants/app_colors.dart';
import '../models/user_goal.dart';
import '../models/water_log.dart';
import '../services/goal_service.dart';
import '../services/water_service.dart';
import '../widgets/custom_button.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  List<WaterLog> waterLogs = [];
  int todayTotal = 0;
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
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    final logs = await WaterService.getTodayWaterLogs();
    final total = await WaterService.getTodayWaterTotal();
    final goal = await GoalService.getGoals();

    if (mounted) {
      setState(() {
        waterLogs = logs;
        todayTotal = total;
        userGoal = goal;
        isLoading = false;
      });
    }
  }

  Future<void> addWater(int amount) async {
    await WaterService.addWaterLog(amount);
    loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added ${amount}ml of water! 💧"),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.cyan.shade700,
        ),
      );
    }
  }

  Future<void> deleteLog(int id) async {
    await WaterService.deleteWaterLog(id);
    loadData();
  }

  void showCustomAmountDialog() {
    final controller = TextEditingController(text: "300");
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.water_drop, color: Colors.cyan),
            SizedBox(width: 10),
            Text("Add Custom Water"),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: "Amount (ml)",
            suffixText: "ml",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                Navigator.pop(ctx);
                addWater(amount);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double percent = (userGoal.waterGoal > 0)
        ? (todayTotal / userGoal.waterGoal).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Water Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Hydration Progress Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 80,
                              lineWidth: 14,
                              percent: percent,
                              animation: true,
                              progressColor: Colors.cyan,
                              backgroundColor: Colors.cyan.shade50,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    size: 38,
                                    color: Colors.cyan,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "$todayTotal",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "/ ${userGoal.waterGoal} ml",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              percent >= 1.0
                                  ? "Great job! Goal Reached! 🎉"
                                  : "${((1.0 - percent) * userGoal.waterGoal).toInt()} ml remaining to reach goal",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: percent >= 1.0
                                    ? AppColors.primary
                                    : AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Quick Add Buttons Title
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quick Add",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _QuickAddCard(
                            amount: 250,
                            label: "Glass",
                            icon: Icons.local_drink,
                            onTap: () => addWater(250),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickAddCard(
                            amount: 500,
                            label: "Bottle",
                            icon: Icons.water_drop,
                            onTap: () => addWater(500),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickAddCard(
                            amount: 750,
                            label: "Large",
                            icon: Icons.local_cafe,
                            onTap: () => addWater(750),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    CustomButton(
                      text: "Custom Amount",
                      icon: Icons.add,
                      color: Colors.cyan.shade600,
                      onPressed: showCustomAmountDialog,
                    ),

                    const SizedBox(height: 30),

                    // Today's Water Logs List
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Today's Hydration Log",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    if (waterLogs.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Icon(
                              Icons.opacity,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No water logged today",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Tap a quick add button to log water intake.",
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: waterLogs.length,
                        itemBuilder: (ctx, index) {
                          final log = waterLogs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.cyan.shade50,
                                child: const Icon(
                                  Icons.local_drink,
                                  color: Colors.cyan,
                                ),
                              ),
                              title: Text(
                                "${log.amount} ml",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(log.timestamp),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => deleteLog(log.id!),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _QuickAddCard extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddCard({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyan.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.cyan, size: 28),
            const SizedBox(height: 8),
            Text(
              "+$amount ml",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
