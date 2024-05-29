import 'package:flutter/material.dart';

import 'regimen_model.dart';

enum AdherenceStatus {
  early,
  late,
  missed,
}

class HistoryModel {
  IconData icon;
  String regimenName;
  String dosage;
  DateTime date;
  RegimenDescriptionModel regimenDescription;
  int id;
  TimeOfDay time;
  String message;
  AdherenceStatus status;

  HistoryModel({
    required this.icon,
    required this.regimenName,
    required this.dosage,
    required this.date,
    required this.regimenDescription,
    required this.id,
    required this.time,
    required this.message,
    required this.status,
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
      status: AdherenceStatus.values[json['status']],
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
      'time': '${time.hour}:${time.minute}',
      'message': message,
      'status': status.index,
    };
  }
}
