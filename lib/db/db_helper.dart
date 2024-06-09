import 'dart:async';
import 'package:get/get.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:nata/models/habit_item_model.dart';
import 'package:nata/models/habit_progress_model.dart';
import 'package:nata/models/user_habit_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('nata.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE HabitItem (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        title TEXT,
        note TEXT,
        date TEXT,
        startTime TEXT,
        endTime TEXT,
        color INTEGER,
        duration INTEGER
      )
      ''');
    } catch (e) {
      print('Error creating HabitItem table: $e');
    }

    try {
      await db.execute('''
      CREATE TABLE UserHabit (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER,
        startDate TEXT,
        endDate TEXT,
        FOREIGN KEY (habitId) REFERENCES HabitItem (id)
      )
      ''');
    } catch (e) {
      print('Error creating UserHabit table: $e');
    }

    try {
      await db.execute('''
      CREATE TABLE HabitProgress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userHabitId INTEGER,
        date_progress TEXT,
        isDone INTEGER,
        FOREIGN KEY (userHabitId) REFERENCES UserHabit (id)
      )
      ''');
    } catch (e) {
      print('Error creating HabitProgress table: $e');
    }
  }

  Future<void> init() async {
    await database;
  }

  // Insert operations
  static Future<int> insertHabitItem(HabitItem? habitItem) async {
    print("Insert HabitItem function called");
    print(habitItem?.toJson());
    return await _database!.insert('HabitItem', habitItem!.toJson());
  }

  // Future<int> insertUserHabit(UserHabit userHabit) async {
  //   final db = await instance.database;
  //   print("Insert UserHabit function called");
  //   print(userHabit.toJson());
  //   return await db.insert('UserHabit', userHabit.toJson());
  // }

Future<int> insertUserHabit(UserHabit userHabit) async {
  final db = await instance.database;
  print("Insert UserHabit function called");
  print(userHabit.toJson());
  int id = await db.insert('UserHabit', userHabit.toJson());

  // Schedule notifications for the new UserHabit
  HabitController controller = Get.find<HabitController>();
  controller.scheduleUserHabitNotifications([userHabit]);

  return id;
}


  Future<int> insertHabitProgress(HabitProgress habitProgress) async {
    final db = await instance.database;
    print("Insert HabitProgress function called");
    return await db.insert('HabitProgress', habitProgress.toJson());
  }

  // Query operations
  Future<List<HabitItem>> getAllHabitItems(String userId) async {
    final db = await instance.database;
    final result = await db
        .query('HabitItem', where: 'userId = ?', whereArgs: [userId]); //coba
    print("query HabitItem function called");
    return result.map((map) => HabitItem.fromJson(map)).toList();
  }

  Future<List<UserHabit>> getAllUserHabits(String userId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT UserHabit.*
    FROM UserHabit
    JOIN HabitItem ON UserHabit.habitId = HabitItem.id
    WHERE HabitItem.userId = ?
  ''', [userId]);
    print("getAllUserHabits function called");
    return result.map((json) => UserHabit.fromJson(json)).toList();
  }

  Future<List<HabitProgress>> getAllHabitProgress(String userId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT HabitProgress.*
    FROM HabitProgress
    JOIN UserHabit ON HabitProgress.userHabitId = UserHabit.id
    JOIN HabitItem ON UserHabit.habitId = HabitItem.id
    WHERE HabitItem.userId = ?
  ''', [userId]);
    print("getAllHabitProgress function called");
    return result.map((json) => HabitProgress.fromJson(json)).toList();
  }

  Future<List<UserHabit>> getUserHabitsForDate(
      String? date, String userId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT UserHabit.*
    FROM UserHabit
    JOIN HabitItem ON UserHabit.habitId = HabitItem.id
    WHERE HabitItem.userId = ? AND
    startDate <= ? AND endDate >= ?
  ''', [userId, date, date]);
    return result.map((json) => UserHabit.fromJson(json)).toList();
  }

  // Update operations
  Future<int> updateHabitItem(HabitItem habitItem) async {
    final db = await instance.database;
    return await db.update(
      'HabitItem',
      habitItem.toJson(),
      where: 'id = ?',
      whereArgs: [habitItem.id],
    );
  }

  Future<int> updateUserHabit(UserHabit userHabit) async {
    final db = await instance.database;
    return await db.update(
      'UserHabit',
      userHabit.toJson(),
      where: 'id = ?',
      whereArgs: [userHabit.id],
    );
  }

  Future<int> updateHabitProgress(HabitProgress habitProgress) async {
    final db = await instance.database;
    return await db.update(
      'HabitProgress',
      habitProgress.toJson(),
      where: 'id = ?',
      whereArgs: [habitProgress.id],
    );
  }

  // Delete operations
  Future<int> deleteHabitItem(int id) async {
    final db = await instance.database;
    print("delete HabitItem function called");
    return await db.delete(
      'HabitItem',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUserHabit(int id) async {
    final db = await instance.database;
    return await db.delete(
      'UserHabit',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHabitProgress(int id) async {
    final db = await instance.database;
    return await db.delete(
      'HabitProgress',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHabitProgressbyDate(int userHabitId) async {
    final db = await instance.database;
    return await db.delete(
      'HabitProgress',
      where: 'userHabitId = ? AND isDone = ?',
      whereArgs: [userHabitId, 1],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
