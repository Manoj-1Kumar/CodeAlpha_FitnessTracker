import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';
import 'core/constants/app_theme.dart';

void main() {
  runApp(const FitnessTracker());
}

class FitnessTracker extends StatelessWidget {
  const FitnessTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fitness Tracker",
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}