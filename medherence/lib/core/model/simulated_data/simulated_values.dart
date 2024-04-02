import 'dart:math';

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

    DateTime generateRandomDate() {
      final now = DateTime.now();
      final random = Random();

      // Generate random year within a specific range (adjust as needed)
      final year =
          now.year + random.nextInt(5) - 2; // -2 to +2 years from current year

      // Generate random month within a specific range (adjust as needed)
      final month = random.nextInt(12) + 1; // 1 to 12 (inclusive)

      // Generate a random day within the chosen month
      final day = random.nextInt(DateTime(year, month, 0).day) +
          1; // 1 to last day of chosen month
      return DateTime(year, month, day);
    }

// Usage in your HistoryModel constructor:
    return HistoryModel(
      icon: icon,
      regimenName: randomRegimenName,
      dosage: randomDosage,
      date: generateRandomDate(),
      regimenDescription:
          regimenDescription, // Include regimen description in HistoryModel
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
    title: "Missed regimen",
    subtitle: "You did not take 2 tablets of Lisinopril",
    read: false,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    title: "Medhecoin",
    subtitle: "You have earned 10 Medhecoins",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    title: "Medhecoin",
    subtitle: "You have earned 120 Medhecoins",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    title: "Medhecoin",
    subtitle: "You have earned 100 Medhecoins",
    read: false,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    title: "Reminder",
    subtitle: "You have 2 tablets of Omeprazole left to use",
    read: false,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    title: "Medhecoin",
    subtitle: "You have earned 40 Medhecoins",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    title: "Motivation",
    subtitle:
        "Taking your medication as prescribed is a crucial step in managing your health and well-being",
    read: true,
    notificationDate: formattedDate,
  ),
  NotificationModel(
    title: "Motivation",
    subtitle:
        "Taking your medication as prescribed is a crucial step in managing your health and well-being",
    read: true,
    notificationDate: formattedDate,
  ),
  // Add more NotificationModel objects as needed
];
