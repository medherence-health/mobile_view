import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String subtitle;
  final bool read;
  final String notificationDate;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.read,
    required this.notificationDate,
  });
}
