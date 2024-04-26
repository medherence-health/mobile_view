import 'package:flutter/material.dart';
import 'regimen_model.dart';

class HistoryModel {
  IconData icon;
  String regimenName;
  String dosage;
  DateTime date;
  RegimenDescriptionModel regimenDescription;
  // Fields representing reminder information
  int id; // Unique identifier for the reminder
  TimeOfDay time; // Time of the reminder
  String message; // Message associated with the reminder

  HistoryModel({
    required this.icon,
    required this.regimenName,
    required this.dosage,
    required this.date,
    required this.regimenDescription,
    required this.id, // Include id field in the constructor
    required this.time, // Include time field in the constructor
    required this.message, // Include message field in the constructor
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      regimenName: json['regimenName'],
      dosage: json['dosage'],
      date: DateTime.parse(json['date']),
      regimenDescription:
          RegimenDescriptionModel.fromJson(json['regimenDescription']),
      id: json['id'],
      time: TimeOfDay.fromDateTime(DateTime.parse(json['time'])),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon.codePoint,
      'regimenName': regimenName,
      'dosage': dosage,
      'date': date.toIso8601String(),
      'regimenDescription': regimenDescription.toJson(),
      'id': id,
      'time': '${time.hour}:${time.minute}', // Convert TimeOfDay to String
      'message': message,
    };
  }
}
