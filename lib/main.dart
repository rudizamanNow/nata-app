import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nata/controller/habit_controller.dart';
import 'package:nata/db/db_helper.dart';
import 'package:nata/services/theme_service.dart';
import 'package:nata/utils/theme_style.dart';
import 'package:nata/view/auth_pages/login_screen.dart';
import 'package:nata/view/menu_pages/menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DatabaseHelper.instance.init();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBdXZEJcYT0gSNk_yDohfvIIq8NQM-UYN8',
    appId: '1:787758699898:android:7352d9c5639e2e54d572c3',
    messagingSenderId: '787758699898',
    projectId: 'nata-app-7b5a6',
    storageBucket: 'nata-app-7b5a6.appspot.com',
  ));

  await _configureLocalTimeZone();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  Get.put(HabitController(flutterLocalNotificationsPlugin));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nata',
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeServices().theme,
        home: const AuthWrapper());
  }
}

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const MyHomePage(
            title: 'Nata',
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
