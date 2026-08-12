import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgressCard extends StatelessWidget {

  final String title;
  final String value;
  final double percent;
  final IconData icon;
  final Color color;

  const CircularProgressCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(18),

        child: Column(

          children: [

            CircularPercentIndicator(

              radius: 42,

              lineWidth: 8,

              percent: percent.clamp(0.0, 1.0),

              animation: true,

              progressColor: color,

              center: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              title,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}