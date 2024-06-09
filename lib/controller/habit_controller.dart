import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nata/db/db_helper.dart';
import 'package:nata/models/habit_item_model.dart';
import 'package:nata/models/habit_progress_model.dart';
import 'package:nata/models/user_habit_model.dart';
import 'package:timezone/timezone.dart' as tz;

class HabitController extends GetxController {
  var habitItems = <HabitItem>[].obs;
  var filteredHabits = <HabitItem>[].obs;
  var userHabits = <UserHabit>[].obs;
  var habitProgress = <HabitProgress>[].obs;
  var habitProgressCount = <int, int>{}.obs;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  HabitController(this.flutterLocalNotificationsPlugin);

  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    if (currentUser != null) {
      loadAllHabits();
      loadAllUserHabits();
    }
  }

  void loadAllHabits() async {
    if (currentUser != null) {
      final habits = await databaseHelper.getAllHabitItems(currentUser!.uid);
      habitItems.assignAll(habits);
      filteredHabits.assignAll(habits);
    }
  }

  void loadAllUserHabits() async {
    if (currentUser != null) {
      final userHabits =
          await databaseHelper.getAllUserHabits(currentUser!.uid);
      this.userHabits.assignAll(userHabits);
      scheduleUserHabitNotifications(userHabits);
    }
  }

  void scheduleUserHabitNotifications(List<UserHabit> userHabits) async {
    for (var userHabit in userHabits) {
      final habitItem =
          habitItems.firstWhere((habit) => habit.id == userHabit.habitId);
      final startTime = DateFormat("HH:mm").parse(habitItem.startTime!);
      final now = DateTime.now();
      final startDate = DateTime.parse(userHabit.startDate!);
      final endDate = DateTime.parse(userHabit.endDate!);

      for (var date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(const Duration(days: 1))) {
        final scheduledTime = DateTime(
            date.year, date.month, date.day, startTime.hour, startTime.minute);

        if (date.isAtSameMomentAs(startDate) && scheduledTime.isAfter(now) ||
            date.isAfter(startDate)) {
          scheduleNotification(habitItem, scheduledTime);
        }
      }
    }
  }

  Future<void> scheduleNotification(
      HabitItem habit, DateTime scheduledTime) async {
    print("Scheduling notification for: ${habit.title} at $scheduledTime");
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'habit_channel_id',
      'habit_channel_name',
      channelDescription: 'Channel for habit notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      habit.id!,
      habit.title,
      habit.note,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      payload: habit.id.toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void loadAllHabitProgress() async {
    final habits = await databaseHelper.getAllHabitProgress(currentUser!.uid);
    habitProgress.assignAll(habits);
    calculateHabitProgressCount();
  }

  void searchHabits(String query) {
    if (query.isEmpty) {
      filteredHabits.assignAll(habitItems);
    } else {
      filteredHabits.assignAll(habitItems.where(
          (habit) => habit.title!.toLowerCase().contains(query.toLowerCase())));
    }
  }

  Future<int> addHabitItem({HabitItem? habitItem}) async {
    habitItem!.userId = currentUser!.uid;
    return await DatabaseHelper.insertHabitItem(habitItem);
  }

  void deleteHabitItem(int id) async {
    await databaseHelper.deleteHabitItem(id);
    loadAllHabits();
    loadAllUserHabits();
  }

  void deleteUserHabitNProgress(int userHabitId) async {
    await databaseHelper.deleteHabitProgressbyDate(userHabitId);
    await databaseHelper.deleteUserHabit(userHabitId);
    loadAllHabitProgress();
    loadAllUserHabits();
  }

  void loadUserHabitsForDate(String? date) async {
    final habits =
        await databaseHelper.getUserHabitsForDate(date, currentUser!.uid);
    userHabits.assignAll(habits);
  }

  void addUserHabit(HabitItem habitItem) async {
    final now = DateTime.now();
    final startDate = now.toString().split(' ')[0];
    final endDate = now
        .add(Duration(days: habitItem.duration! - 1))
        .toString()
        .split(' ')[0];

    final userHabit = UserHabit(
      habitId: habitItem.id!,
      startDate: startDate,
      endDate: endDate,
    );

    await databaseHelper.insertUserHabit(userHabit);
    loadAllUserHabits();
  }

  void markHabitAsDone(int userHabitId, String date) async {
    final habitProgress = HabitProgress(
      userHabitId: userHabitId,
      date_progress: date,
      isDone: 1,
    );
    await databaseHelper.insertHabitProgress(habitProgress);
    print(habitProgress.toJson());
    loadAllHabitProgress();
    loadUserHabitsForDate(date);
  }

  List<double> getDoneHabitPerDay() {
    List<double> doneHabitCounts = List.generate(7, (index) => 0.0);

    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday));

    for (var progress in habitProgress) {
      DateTime progressDate = DateTime.parse(progress.date_progress!);
      if (progress.isDone == 1) {
        int dayDiff = progressDate.difference(startOfWeek).inDays;
        if (dayDiff >= 0 && dayDiff < 7) {
          doneHabitCounts[dayDiff] += 1;
        }
      }
    }

    return doneHabitCounts;
  }

  int getLongestStreak() {
    int longestStreak = 0;
    int currentStreak = 0;

    DateTime? lastDate;
    bool isStreak = false;

    for (var progress in habitProgress) {
      if (progress.isDone == 1) {
        DateTime progressDate = DateTime.parse(progress.date_progress!);
        if (isStreak) {
          if (lastDate != null &&
              lastDate.add(Duration(days: 1)) == progressDate) {
            currentStreak++;
          } else {
            if (currentStreak > longestStreak) {
              longestStreak = currentStreak;
            }
            currentStreak = 1;
          }
        } else {
          isStreak = true;
          currentStreak = 1;
        }
        lastDate = progressDate;
      }
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    return longestStreak;
  }

  Map<String, int> getBestDay() {
    Map<String, int> dayCounts = {};
    List<String> daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    for (var progress in habitProgress) {
      if (progress.isDone == 1) {
        int weekdayIndex = DateTime.parse(progress.date_progress!).weekday;
        String dayOfWeek = daysOfWeek[weekdayIndex -
            1];

        if (dayCounts.containsKey(dayOfWeek)) {
          dayCounts[dayOfWeek] = dayCounts[dayOfWeek]! + 1;
        } else {
          dayCounts[dayOfWeek] = 1;
        }
      }
    }

    String bestDay = 'Nothing';
    int maxCount = 0;

    dayCounts.forEach((day, count) {
      if (count > maxCount) {
        maxCount = count;
        bestDay = day;
      }
    });

    return {bestDay: maxCount};
  }

  void calculateHabitProgressCount() {
    Map<int, int> progressCount = {};
    for (var progress in habitProgress) {
      if (progress.isDone == 1) {
        if (progressCount.containsKey(progress.userHabitId)) {
          progressCount[progress.userHabitId!] = progressCount[progress.userHabitId]! + 1;
        } else {
          progressCount[progress.userHabitId!] = 1;
        }
      }
    }
    habitProgressCount.assignAll(progressCount);
  }
}
