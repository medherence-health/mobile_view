import 'package:flutter/material.dart';

import 'regimen_model.dart';

class HistoryModel {
  IconData icon;
  String regimenName;
  String dosage;
  DateTime date;
  RegimenDescriptionModel regimenDescription; // Add this field

  HistoryModel({
    required this.icon,
    required this.regimenName,
    required this.dosage,
    required this.date,
    required this.regimenDescription, // Update constructor to include regimenDescription
  });
}
