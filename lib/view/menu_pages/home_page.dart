import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/models/habit_item_model.dart';
import 'package:nata/models/habit_progress_model.dart';
import 'package:nata/models/user_habit_model.dart';
import 'package:nata/services/theme_service.dart';
import 'package:nata/utils/colors.dart';
import 'package:nata/utils/home_habit_tile.dart';
import 'package:nata/utils/theme_style.dart';
import 'package:nata/view/menu_pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _habitController = Get.find<HabitController>();

  @override
  void initState() {
    super.initState();
    _habitController.loadAllHabits();
    _habitController.loadUserHabitsForDate(DateFormat('yyyy-MM-dd').format(_selectedDate));
    _habitController.loadAllHabitProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        children: [
          _addHabitbar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showHabits(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
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
    );
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 90,
        width: 70,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
            _habitController.loadUserHabitsForDate(DateFormat('yyyy-MM-dd').format(_selectedDate));
          });
        },
      ),
    );
  }

  Widget _addHabitbar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          // MyButton(
          //   label: "+ Add Habit",
          //   onTab: () async {
          //     await Get.to(() => const AddHabitPage());
          //     _habitController.loadUserHabitsForDate(DateTime.now());
          //   },
          // )
        ],
      ),
    );
  }

  Widget _showHabits() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _habitController.userHabits.length,
          itemBuilder: (_, index) {
            UserHabit userHabit = _habitController.userHabits[index];
            HabitItem habitItem = _habitController.habitItems.firstWhere((habit) => habit.id == userHabit.habitId);
            HabitProgress? habitProgress = _habitController.habitProgress.firstWhereOrNull((progress) => progress.userHabitId == userHabit.id && progress.date_progress == DateFormat('yyyy-MM-dd').format(_selectedDate));
            print(habitItem.toJson());
            print(userHabit.toJson());
            print(habitProgress?.toJson());
            print("---------------------------------------------------------------------------");
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, userHabit);
                        },
                        child: HomeHabitTile(habitItem, userHabit: userHabit, habitProgress: habitProgress),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  

  _showBottomSheet(BuildContext context, UserHabit userHabit) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            _bottomSheetButton(
              label: "Done",
              onTap: () {
                _habitController.markHabitAsDone(userHabit.id!, DateFormat('yyyy-MM-dd').format(_selectedDate));
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),
            _bottomSheetButton(
              label: "Delete",
              onTap: () {
                _habitController.deleteUserHabitNProgress(userHabit.id!);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.white,
              isClosed: true,
              context: context,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClosed = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClosed == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClosed == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClosed
                ? titleStyle
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
