import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/models/habit_item_model.dart';
import 'package:nata/utils/colors.dart';
import 'package:nata/utils/habit_tile.dart';
import 'package:nata/utils/theme_style.dart';
import 'package:nata/view/menu_pages/profile_page.dart';

class ExploreHabitPage extends StatefulWidget {
  const ExploreHabitPage({super.key});

  @override
  State<ExploreHabitPage> createState() => _ExploreHabitPageState();
}

class _ExploreHabitPageState extends State<ExploreHabitPage> {
  final _habitController = Get.find<HabitController>();
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _habitController.loadAllHabits();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.colorScheme.background,
      body: Column(
        children: [
          _searchHabitbar(),
          const SizedBox(
            height: 10,
          ),
          _showHabits(),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Explore Habits'),
      titleTextStyle: subHeadingStyle.copyWith(color: Colors.grey[600]),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      actions: [
        GestureDetector(
          onTap: () {
            _focusNode.unfocus();
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

  _searchHabitbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          prefixIconColor: const Color(0xFFC8CDD9),
          prefixIcon: const Padding(
            padding: EdgeInsetsDirectional.only(start: 25.0, end: 15),
            child: Icon(Icons.search),
          ),
          hintText: 'Search Habits',
          hintStyle: const TextStyle(
            color: Color(0xFFC8CDD9),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
        ),
        onChanged: (query) {
          _habitController.searchHabits(query);
        },
      ),
    );
  }

  _showHabits() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _habitController.filteredHabits.length,
            itemBuilder: (_, index) {
              HabitItem habit = _habitController.filteredHabits[index];

              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                    child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _focusNode.unfocus();
                          _showBottomSheet(context, habit);
                        },
                        child: HabitTile(habit),
                      ),
                    ],
                  ),
                )),
              );
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, HabitItem habit) {
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
              label: "Add to My Habit",
              onTap: () {
                _habitController.addUserHabit(habit);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),
            _bottomSheetButton(
              label: "Delete",
              onTap: () {
                _habitController.deleteHabitItem(habit.id!);
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
