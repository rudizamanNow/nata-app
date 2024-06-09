import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nata/models/habit_item_model.dart';
import 'package:nata/models/user_habit_model.dart';

class HabitTile extends StatelessWidget {
  final HabitItem? habitItem;
  final UserHabit? userHabit;
  const HabitTile(this.habitItem, {super.key, this.userHabit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
                            color: Color(0xFF2C406E)),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Color(0xFF9AA8C7),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${habitItem!.startTime} - ${habitItem!.endTime}",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 13, color: Color(0xFF9AA8C7)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.assignment_outlined,
                          color: Color(0xFF9AA8C7),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          habitItem?.note ?? "",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 13, color: Color(0xFF9AA8C7)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(49, 143, 154, 235),
                      ),
                      child: Text(
                        "${habitItem!.duration} Days",
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
        ]),
      ),
    );
  }
}
