import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nata/utils/theme_style.dart';
import 'package:nata/view/menu_pages/profile_page.dart';
import 'package:nata/widgets/best_day.dart';
import 'package:nata/widgets/progress_by_habit.dart';
import 'package:nata/widgets/streaks.dart';
import 'package:nata/widgets/weekly_chart.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Progress'),
          titleTextStyle: subHeadingStyle.copyWith(color: Colors.grey[600]),
          elevation: 0,
          backgroundColor: context.theme.colorScheme.background,
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => const ProfilePage());
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                  "Assets/images/profile.png",
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            children: [
              Hero(
                tag: 'WeeklyChart',
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFD),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weekly Progress',
                                style: titleStyle,
                              ),
                              const SizedBox(height: 15),
                              const SizedBox(
                                height: 200,
                                child: WeeklyChart(),
                              )
                            ]))),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFD),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Streaks(),
                        )),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFD),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: BestDay(),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFD),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: HabitProgressStats(),
                  ))
            ]));
  }
}
