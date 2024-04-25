import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  late BuildContext context;
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

  ShowNotification(HistoryModel model) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
      model.id, // Use the ID of the HistoryModel as the notification ID
      model.regimenName, // Use the regimen name as the notification title
      model.message,
      notificationDetails,
      payload: model.id.toString(),
    );
    notifyListeners();
  }

  Future<void> scheduleAlarmsFromSavedReminders() async {
    for (var reminder in modelList) {
      scheduleNotification(reminder);
      debugPrint('reminder in the model list is : $reminder');
    }
    notifyListeners();
  }

  Future<void> scheduleNotification(HistoryModel reminder) async {
    int notificationId = reminder.id;

    DateTime futureDateTime = reminder.date; // Schedule for tomorrow
    if (futureDateTime.isBefore(now)) {
      futureDateTime = futureDateTime.add(const Duration(days: 1));
    }
    int newTime = futureDateTime.millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;
    debugPrint('future time is: $futureDateTime');
    debugPrint('The new time is: $newTime');
    await flutterLocalNotificationsPlugin?.zonedSchedule(
      notificationId,
      'Alarm',
      reminder.message,
      tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newTime)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          sound: RawResourceAndroidNotificationSound('alarm'),
          autoCancel: false,
          playSound: true,
          priority: Priority.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    notifyListeners();
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin!.cancel(notificationId);
  }
}
