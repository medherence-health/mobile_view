import 'dart:convert';
import 'dart:typed_data';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medherence/core/model/models/history_model.dart';
import 'package:medherence/core/utils/image_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../features/monitor/view/alarm_monitor.dart';
import '../model/simulated_data/simulated_values.dart';
import '../../features/dashboard_feature/view/dashboard_view.dart';

class NotificationService extends ChangeNotifier {
  late SharedPreferences preferences;

  List<HistoryModel> modelList = generateSimulatedData();

  // List<HistoryModel> get modelList => modelList;

  List<String> listofstring = [];

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  late BuildContext context; // Define context here

  // Constructor to pass the BuildContext
  NotificationService(this.context);
  // GetData() async {
  //   preferences = await SharedPreferences.getInstance();
  //   List<String>? cominglist = await preferences.getStringList("data");
  //   if (cominglist == null) {
  //   } else {
  //     modelList =
  //         cominglist.map((e) => HistoryModel.fromJson(json.decode(e))).toList();
  //     debugPrint('Model list is $modelList');
  //     notifyListeners();
  //   }
  // }

  // SetData() {
  //   List<String> listofstring =
  //       modelList.map((e) => json.encode(e.toJson())).toList();
  //   preferences.setStringList("data", listofstring);
  //   notifyListeners();
  // }

  Future<void> init() async {
    var androidInitilize = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = DarwinInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initilizationsSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    // Schedule alarms from saved reminders
    await scheduleAlarmsFromSavedReminders();
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardView()));
  }

  // void onDidReceiveNotificationResponse(
  //   NotificationResponse notificationResponse,
  // ) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     debugPrint('notification payload: $payload');
  //     // Parse the payload to get the ID of the reminder
  //     int reminderId = int.parse(payload!); // Assuming the payload is the ID
  //     // Find the corresponding HistoryModel instance
  //     HistoryModel? model = modelList.firstWhere(
  //       (element) => element.id == reminderId,
  //     );
  //     if (model != null) {
  //       // If the model is found, navigate to the AlarmMonitor with the corresponding data
  //       await Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute<void>(
  //           builder: (context) => AlarmMonitor(
  //             subtitle: model.message,
  //             regimen: model.regimenName,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  ShowNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Alarm channel',
      'Alarms ',
      channelDescription: 'Alarm Notification',
      importance: Importance.max,
      priority: Priority.high,
      sound: const RawResourceAndroidNotificationSound('alarm'),
      autoCancel: true,
      playSound: true,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      audioAttributesUsage: AudioAttributesUsage.alarm,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      fullScreenIntent: true,
      additionalFlags: Int32List.fromList(<int>[
        0x00000001, // FLAG_INSISTENT (Requires VIBRATE permission)
      ]),
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
      0, // Use the ID of the HistoryModel as the notification ID
      'plain title', // Use the regimen name as the notification title
      'plain body',
      notificationDetails,
      payload: 'item x',
    );
    notifyListeners();
  }

  Future<void> scheduleAlarmsFromSavedReminders() async {
    for (var reminder in modelList) {
      scheduleNotification(reminder);
      debugPrint('reminder in the model list is : $reminder');
      debugPrint('alarms scheduled successfully!!!!!!');
    }
    notifyListeners();
  }

  Future<void> scheduleNotification(HistoryModel reminder) async {
    int notificationId = reminder.id;
    // Get current date and time
    final now = DateTime.now();
    // Calculate target time (desired minutes from now)
    final int targetMinutesFromNow =
        2; // Replace with desired minutes (e.g., 1 or 2)
    var targetTime = now.add(Duration(minutes: targetMinutesFromNow));

    // Check for past time (optional)
    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(const Duration(days: 1));
    }
    final futureDateTime = targetTime;
    int newTime = futureDateTime.millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;
//     final String formattedTimeString = DateFormat('hh:mm a').format(DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//       reminder.time.hour,
//       reminder.time.minute,
//     ));

// // Optional: Parse formatted string back to DateTime (for readability)
//     DateTime scheduledTime;
//     try {
//       scheduledTime = DateTime.parse(formattedTimeString);
//     } catch (e) {
//       // Handle parsing error
//       return;
//     }

// // Calculate milliseconds difference
//     final int addNewTime = scheduledTime.millisecondsSinceEpoch -
//         DateTime.now().millisecondsSinceEpoch;
    debugPrint('future time is: $futureDateTime');
    debugPrint('The new time is: $newTime');
    await flutterLocalNotificationsPlugin?.zonedSchedule(
      notificationId,
      'Alarm',
      reminder.message,
      tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newTime)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          sound: RawResourceAndroidNotificationSound('alarm'),
          autoCancel: true,
          playSound: true,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          audioAttributesUsage: AudioAttributesUsage.alarm,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
          fullScreenIntent: true,
          additionalFlags: Int32List.fromList(<int>[
            0x00000001, // FLAG_INSISTENT (Requires VIBRATE permission)
          ]),
        ),
      ),
      payload: notificationId.toString(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    notifyListeners();
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin!.cancel(notificationId);
  }

  // Callback function for the action
  Future<void> stopAlarmAction(int notificationId) async {
    // Stop the alarm here
    // For example:
    await AndroidAlarmManager.cancel(notificationId);
  }
}
