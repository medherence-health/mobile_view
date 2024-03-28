import 'dart:math';

import 'package:flutter/material.dart';

import 'package:medherence/core/model/models/history_model.dart';

List<HistoryModel> generateSimulatedData() {
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

    // Generate random regimen names
    List<String> regimenNames = ['Omeprazole', 'Lisinopril', 'Azithromycin', ''];
    String randomRegimenName = regimenNames[index % 3];

    // Generate random dosages
    List<String> dosages = ['1 Capsule', '2 Tablets', '1 Syrup'];
    String randomDosage = dosages[index % 3];

    DateTime generateRandomDate() {
  final now = DateTime.now();
  final random = Random();

  // Generate random year within a specific range (adjust as needed)
  final year = now.year + random.nextInt(5) - 2; // -2 to +2 years from current year

  // Generate random month within a specific range (adjust as needed)
  final month = random.nextInt(12) + 1; // 1 to 12 (inclusive)

  // Generate a random day within the chosen month
  final day = random.nextInt(DateTime(year, month, 0).day) + 1; // 1 to last day of chosen month
  return DateTime(year, month, day);
}

// Usage in your HistoryModel constructor:
return HistoryModel(
  icon: icon,
  regimenName: randomRegimenName,
  dosage: randomDosage,
  date: generateRandomDate(),
);
  });
}