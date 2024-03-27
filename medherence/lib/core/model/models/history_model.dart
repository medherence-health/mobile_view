import 'package:flutter/material.dart';

class HistoryModel{
  IconData icon;
  String regimenName;
  String dosage;
  DateTime date;

  HistoryModel({
    required this.icon,
    required this.regimenName,
    required this.dosage,
    required this.date,
  });
}