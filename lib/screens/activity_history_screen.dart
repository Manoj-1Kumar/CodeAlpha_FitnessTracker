import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_utils.dart';
import '../database/database_helper.dart';
import '../models/activity.dart';
import '../widgets/activity_card.dart';
import 'add_activity_screen.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  List<Activity> allActivities = [];
  List<Activity> filteredActivities = [];
  String searchQuery = "";
  String selectedFilter = "All";
  bool isLoading = true;

  final List<String> categories = [
    "All",
    "Running",
    "Walking",
    "Gym",
    "Cycling",
    "Swimming",
    "Yoga"
  ];

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    setState(() => isLoading = true);
    final list = await DatabaseHelper.instance.getActivities();
    if (mounted) {
      setState(() {
        allActivities = list;
        applyFilter();
        isLoading = false;
      });
    }
  }

  void applyFilter() {
    List<Activity> temp = List.from(allActivities);

    if (selectedFilter != "All") {
      temp = temp.where((e) {
        return e.exercise.toLowerCase().contains(selectedFilter.toLowerCase());
      }).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      temp = temp.where((e) {
        return e.exercise.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    filteredActivities = temp;
  }

  Future<void> deleteActivity(int id) async {
    await DatabaseHelper.instance.delete(id);
    loadActivities();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Activity deleted"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Activity Log History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddActivityScreen()),
              );
              loadActivities();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadActivities,
              child: Column(
                children: [
                  // Search & Category Chips
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search exercise...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val;
                          applyFilter();
                        });
                      },
                    ),
                  ),

                  // Category Filter Horizontal List
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: categories.length,
                      itemBuilder: (ctx, idx) {
                        final cat = categories[idx];
                        final isSelected = cat == selectedFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textDark,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedFilter = cat;
                                applyFilter();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Activities List
                  Expanded(
                    child: filteredActivities.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fitness_center_outlined,
                                  size: 70,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "No activities match your criteria",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Try changing search terms or add a new workout.",
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(18),
                            itemCount: filteredActivities.length,
                            itemBuilder: (ctx, idx) {
                              final activity = filteredActivities[idx];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (idx == 0 ||
                                        filteredActivities[idx - 1].date != activity.date)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                                        child: Text(
                                          AppDateUtils.formatDisplayDate(activity.date),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textLight,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ActivityCard(
                                      activity: activity,
                                      onDelete: () => deleteActivity(activity.id!),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
