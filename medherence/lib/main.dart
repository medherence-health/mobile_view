import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medherence/features/medhecoin/view_model/medhecoin_wallet_view_model.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:medherence/features/splashscreen/splashscreen.dart';
import 'core/providers/faq_provider.dart';
import 'core/service/notification_service.dart';
import 'core/utils/color_utils.dart';
import 'core/utils/utils.dart';
import 'core/model/models/notification_model.dart';
import 'features/history/view_model/filter_model.dart';
import 'features/monitor/view_model/reminder_view_model.dart';
import 'features/profile/view_model/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Android Alarm Manager
  await AndroidAlarmManager.initialize();

  // Initialize timezone data for Flutter Local Notifications
  tz.initializeTimeZones();

  // Request notification permissions for Android
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

  // Initialize notification services
  await NotificationService().init();

  // Set preferred orientation to portrait mode only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Customize system UI overlay style (e.g., status bar color)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent, // Example: Set status bar color
  ));

  // Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers for various application features and services
        ChangeNotifierProvider(create: (context) => NotificationModelItems()),
        ChangeNotifierProvider(create: (context) => ReminderState()),
        ChangeNotifierProvider(create: (context) => NotificationService()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => FAQProvider()),
        ChangeNotifierProvider(create: (context) => FilterViewModel()),
        ChangeNotifierProvider(create: (context) => WalletViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Disable debug banner
        title: 'Medical adherence', // Set the application title
        themeMode: ThemeMode.system, // Use system-defined theme mode
        theme: ThemeData(
          brightness: Brightness.light, // Use light theme by default
          scaffoldBackgroundColor: Colors.white, // Default background color
          colorScheme: const ColorScheme.light(
            primary: AppColors.navBarColor, // Define primary color
          ),
          useMaterial3: true, // Enable Material 3 design
          fontFamily: StringUtils.poppins, // Set default font family
          appBarTheme: const AppBarTheme(
            elevation: 0, // No elevation for app bar
            backgroundColor: Colors.white, // App bar background color
            iconTheme: IconThemeData(
              color: AppColors.navBarColor, // App bar icon color
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.pressedButton, // Text cursor color
            selectionHandleColor: AppColors.midOrange, // Selection handle color
            selectionColor:
                AppColors.pressedButton.withOpacity(0.3), // Selection color
          ),
        ),
        home: const SplashScreen(), // Initial route is SplashScreen
      ),
    );
  }
}
