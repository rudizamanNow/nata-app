import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/utils/theme_style.dart';

class Streaks extends StatelessWidget {
  const Streaks({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<HabitController>(
      builder: (controller) {
        final longestStreak = controller.getLongestStreak();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Longest Streaks',
              style: titleStyle,
            ),
            const SizedBox(height: 5),
            Text(
              '$longestStreak days',
              style: headingStyle,
            ),
          ],
        );
      },
    );
  }
}
