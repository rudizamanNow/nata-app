import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/utils/theme_style.dart';

class BestDay extends StatelessWidget {
  const BestDay({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<HabitController>(
      builder: (controller) {
        final bestDayData = controller.getBestDay();
        final bestDay = bestDayData.keys.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Best Day',
              style: titleStyle,
            ),
            const SizedBox(height: 5),
            Text(
              bestDay,
              style: headingStyle,
            ),
          ],
        );
      },
    );
  }
}
