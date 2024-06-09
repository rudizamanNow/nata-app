import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/utils/theme_style.dart';

class HabitProgressStats extends StatelessWidget {
  const HabitProgressStats({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find();

    return Obx(() {
      if (controller.habitItems.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Habit Progress Statistics', style: titleStyle),
            const SizedBox(height: 15),
            const Text('Tidak ada data statistik tersedia'),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Habit Progress Statistics', style: titleStyle),
            const SizedBox(height: 15),
            ...controller.habitItems.map((habit) {
              int progressCount = controller.habitProgressCount[habit.id] ?? 0;
              return ListTile(
                title: Text(habit.title!),
                trailing: Text('$progressCount times'),
              );
            }).toList(),
          ],
        );
      }
    });
  }
}


