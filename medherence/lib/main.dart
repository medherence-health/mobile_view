import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:medherence/features/splashscreen/splashscreen.dart';
import 'core/providers/faq_provider.dart';
import 'core/service/notification_service.dart';
import 'core/utils/color_utils.dart';
import 'core/utils/utils.dart';
import 'core/model/models/notification_model.dart';
import 'features/monitor/view/alarm_monitor.dart';
import 'features/monitor/view_model/reminder_view_model.dart';
import 'features/profile/view_model/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  tz.initializeTimeZones();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();
  await NotificationService().init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.white, // Example: Set status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NotificationModelItems()),
          ChangeNotifierProvider(create: (context) => ReminderState()),
          ChangeNotifierProvider(create: (context) => NotificationService()),
          ChangeNotifierProvider(create: (context) => ProfileViewModel()),
          ChangeNotifierProvider(create: (context) => FAQProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Medical adherence',
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            // colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navBarColor),
            colorScheme: const ColorScheme.light(
              primary: AppColors.navBarColor,
            ),
            useMaterial3: true,
            fontFamily: StringUtils.poppins,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: AppColors.navBarColor,
              ),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.pressedButton,
              selectionHandleColor: AppColors.midOrange,
              selectionColor: AppColors.pressedButton.withOpacity(0.3),
            ),
          ),
          home: const SplashScreen(),
        ));
  }
}
