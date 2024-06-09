import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nata/models/habit_item_model.dart';
import 'package:nata/models/habit_progress_model.dart';
import 'package:nata/models/user_habit_model.dart';

class HomeHabitTile extends StatelessWidget {
  final HabitItem? habitItem;
  final UserHabit? userHabit;
  final HabitProgress? habitProgress;
  const HomeHabitTile(this.habitItem,
      {super.key, this.userHabit, this.habitProgress});

  @override
  Widget build(BuildContext context) {
    final remainingDays = _calculateRemainingDays(userHabit?.endDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 16, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF9FAFD),
        ),
        child: Row(children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  height: 78,
                  width: 2.5,
                  color: const Color(0xFF8F99EB),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitItem?.title ?? "",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${habitItem!.startTime} - ${habitItem!.endTime}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          habitItem?.note ?? "",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: _getBGClr(habitItem?.color ?? 0),
                        color: const Color.fromARGB(49, 143, 154, 235),
                      ),
                      child: Text(
                        "$remainingDays Days Remaining",
                        style: GoogleFonts.lato(
                          textStyle:
                              const TextStyle(fontSize: 12, color: Color(0xFF8F99EB)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              habitProgress?.isDone == 1 ? "DONE" : "PENDING",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8F99EB),
                  ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  int _calculateRemainingDays(String? endDate) {
    if (endDate == null) return 0;
    final end = DateTime.parse(endDate);
    final now = DateTime.now();
    final remaining = end.difference(now).inDays + 1;
    return remaining > 0 ? remaining : 0;
  }
}
