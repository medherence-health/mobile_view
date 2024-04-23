import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medherence/core/utils/image_utils.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService with ChangeNotifier {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future<void> initializeNotifications() async {
  //   final AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  // onSelectNotification: (String? payload) async {
  //   // Navigate to the AlarmMonitor screen when notification is tapped

  // },
  //   );
  // }

  // Future<void> scheduleAlarm(DateTime alarmTime) async {
  //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'alarm_channel_id',
  //     'Alarm notifications',
  //     'Shows alarm notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     sound: RawResourceAndroidNotificationSound('alarm_sound'),
  //   );
  //   final NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //   );
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'Alarm',
  //     'Time to take your medication!',
  //     tz.TZDateTime.from(alarmTime, tz.local),
  //     platformChannelSpecifics,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Replace with your icon

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
    notifyListeners();
  }

  Future<void> showScheduledNotification(
    String regimenName,
    String dosage,
  ) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            importance: Importance.high, priority: Priority.high);
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    // Construct the alarm details
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(const Duration(seconds: 5));

    await _notificationsPlugin.zonedSchedule(
      0, // Notification ID (unique for each notification)
      'Medication Reminder', // Notification Title
      'It\'s time to take your $regimenName medication. Dosage: $dosage', // Notification Body
      scheduledTime, // Scheduled time
      notificationDetails,
      androidAllowWhileIdle: true,
      payload: 'data',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    ); // Optional data to pass to the screen
    notifyListeners();
  }

  // Future<void> showScheduledNotification(
  //   String regimen,
  //   DateTime scheduledTime,
  // ) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails('channel_id', 'channel_name',
  //           importance: Importance.high, priority: Priority.high);
  //   final NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //   );

  //   await _notificationsPlugin.zonedSchedule(
  //     0, // Notification ID (unique for each notification)
  //     'Medication Reminder', // Notification Title
  //     'It\'s time to take your $regimen medication.', // Notification Body
  //     tz.TZDateTime.from(scheduledTime, tz.local), // Scheduled time
  //     notificationDetails,
  //     androidAllowWhileIdle: true,
  //     payload: 'data',
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   ); // Optional data to pass to the screen
  // }
}
