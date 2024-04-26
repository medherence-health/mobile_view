import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:medherence/core/model/models/history_model.dart';

import '../models/notification_model.dart';
import '../models/regimen_model.dart';

List<HistoryModel> generateSimulatedData() {
  List<RegimenDescriptionModel> regimenDescriptions =
      generateSimulatedRegimenDescriptions();

  return List.generate(5, (index) {
    // Generate random icons
    IconData icon;
    switch (index % 3) {
      case 0:
        icon = Icons.medical_services;
        break;
      case 1:
        icon = Icons.healing;
        break;
      case 2:
        icon = Icons.medical_services;
        break;
      default:
        icon = Icons.local_hospital;
    }
    // Select a random regimen description
    RegimenDescriptionModel regimenDescription =
        regimenDescriptions[index % regimenDescriptions.length];

    // Generate random regimen names
    List<String> regimenNames = [
      'Omeprazole',
      'Lisinopril',
      'Azithromycin',
      'Rituximab'
    ];
    String randomRegimenName = regimenNames[index % 3];

    // Generate random dosages
    List<String> dosages = ['1 Capsule', '2 Tablets', '1 Syrup'];
    String randomDosage = dosages[index % 3];
    final random = math.Random();
    final int randomHour = random.nextInt(12) + 1;
    final int randomMinute = random.nextInt(60);
    final now = DateTime.now();
    final oneMinuteFromNow =
        now.add(const Duration(minutes: 1)); // Add 1 minute
    final String formattedTime = DateFormat('hh:mm a').format(oneMinuteFromNow);
    // final String formattedTime = DateFormat('hh:mm a').format(
    //   DateTime(
    //     DateTime.now().year,
    //     DateTime.now().month,
    //     DateTime.now().day,
    //     randomHour,
    //     randomMinute,
    //   ),
    // );
    // Generate random reminder information
    int id = index + 1; // Example: 1, 2, 3, ...
    String message = 'Take $randomDosage of $randomRegimenName medication';

    // DateTime generateRandomDate() {
    //   final now = DateTime.now();

    //   // Generate a random number of days in the future (adjust as needed)
    //   final int futureDays =
    //       random.nextInt(365) + 1; // 1 to 365 days in the future

    //   return now.add(Duration(days: futureDays));
    // }
    final List<int> desiredHours = [9, 13, 17]; // Example: 9 AM, 1 PM, 5 PM
    final List<int> desiredMinutes = [
      0,
      30
    ]; // Example: 0 minutes past the hour, 30 minutes past the hour

    final int randomHourIndex = random.nextInt(desiredHours.length);
    final int randomMinuteIndex = random.nextInt(desiredMinutes.length);

    final int desiredHour = desiredHours[randomHourIndex];
    final int desiredMinute = desiredMinutes[randomMinuteIndex];

    // final now = DateTime.now();
    final notificationTime =
        TimeOfDay(hour: desiredHour, minute: desiredMinute);

    // Combine date and time for notification
    final futureDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );

// Usage in your HistoryModel constructor:
    return HistoryModel(
      icon: icon,
      regimenName: randomRegimenName,
      dosage: randomDosage,
      date: futureDateTime,
      regimenDescription:
          regimenDescription, // Include regimen description in HistoryModel
      id: id, // Include id field
      time: notificationTime, // Include time field
      message: message,
    );
  });
}

List<RegimenDescriptionModel> generateSimulatedRegimenDescriptions() {
  return [
    RegimenDescriptionModel(
      medicationForm: 'Tablet',
      dose: '2 tablets',
      pillTime: '2:00 pm',
      pillFrequency: 'Once a day',
      duration: '30 days',
      notes: 'To be taken before food',
    ),
    RegimenDescriptionModel(
      medicationForm: 'Capsule',
      dose: '1 capsule',
      pillTime: '8:00 am',
      pillFrequency: 'Twice a day',
      duration: '14 days',
      notes: 'Take with plenty of water',
    ),
    RegimenDescriptionModel(
      medicationForm: 'Syrup',
      dose: '10 ml',
      pillTime: '9:00 pm',
      pillFrequency: 'Once a day',
      duration: '60 days',
      notes: 'Refrigerate after opening',
    ),
    RegimenDescriptionModel(
      medicationForm: 'Tablet',
      dose: '2 tablets',
      pillTime: '9:00 pm',
      pillFrequency: 'Thrice a day',
      duration: '14 days',
      notes: 'To be taken after meal',
    ),
    // Add more simulated data here if needed
  ];
}

DateTime now = DateTime.now();

final formattedDate = DateFormat('dd/MM').format(now);

print(formattedDate) {
  // TODO: implement print
  throw UnimplementedError();
}

List<NotificationModel> notificationLists = [
  NotificationModel(
    id: "1",
    title: "Missed regimen",
    subtitle: "You did not take 2 tablets of Lisinopril",
    read: false,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "2",
    title: "Medhecoin",
    subtitle: "You have earned 10 Medhecoins",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "3",
    title: "Medhecoin",
    subtitle: "You have earned 120 Medhecoins",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "4",
    title: "Medhecoin",
    subtitle: "You have earned 100 Medhecoins",
    read: false,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "5",
    title: "Reminder",
    subtitle: "You have 2 tablets of Omeprazole left to use",
    read: false,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "6",
    title: "Medhecoin",
    subtitle: "You have earned 40 Medhecoins",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "7",
    title: "Motivation",
    subtitle:
        "Taking your medication as prescribed is a crucial step in managing your health and well-being",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "8",
    title: "Motivation",
    subtitle:
        "Taking your medication as prescribed is a crucial step in managing your health and well-being",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    id: "9",
    title: "Motivation",
    subtitle:
        "Ensuring a proper intake of medication fastening a good stable and quick growth",
    read: false,
    notificationDate: formattedDate,
  ),
  // Add more NotificationModel objects as needed
];
