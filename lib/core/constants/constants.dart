import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/color_utils.dart';

InputDecoration kFormTextDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.grey.shade500,
  ),
  filled: true,
  fillColor: AppColors.textFilledColor,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      (10),
    ),
    borderSide: BorderSide(
      width: (2),
      color: Colors.grey.shade500,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      (10),
    ),
    borderSide: const BorderSide(
      width: (2),
      color: Colors.black87,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red),
  ),
);

InputDecoration kProfileInputDecoration = InputDecoration(
  filled: true,
  // fillColor: Colors.white70,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      (10),
    ),
    borderSide: const BorderSide(
      width: (2),
      color: Colors.black87,
    ),
  ),
);

String ok = "OK";
String notUsed = "not_used";

int currentTimeInMilli = DateTime.now().millisecondsSinceEpoch;

int addHoursToCurrentMillis(int hours) {
  int addedMillis = hours * 60 * 60 * 1000; // Convert hours to milliseconds
  return currentTimeInMilli + addedMillis;
}

int cyclesLeftUntil(int endDateMillis, int freq) {
  int currentMillis = DateTime.now().millisecondsSinceEpoch;
  int differenceMillis = endDateMillis - currentMillis;

  if (differenceMillis <= 0) {
    return 0; // If the end date has already passed, return 0 hours
  }

  int hoursLeft =
      (differenceMillis / (60 * 60 * 1000)).floor(); // Convert to hours
  return (hoursLeft / freq).floor();
}

int getHoursBetween(int startMillis, int endMillis) {
  return ((endMillis - startMillis) / (1000 * 60 * 60)).round();
}

NumberFormat kNumFormatNoDecimal = NumberFormat('#,###');

NumberFormat kNumFormatDecimal = NumberFormat('#,###.0#');

Map<String, String> formatDateTime(int milliseconds) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

  return {
    'date': DateFormat('dd-MM-yy').format(dateTime),
    'time': DateFormat('h:mm a').format(dateTime),
    'day': DateFormat('EEEE').format(dateTime),
    'month': DateFormat('MMMM').format(dateTime),
    'year': DateFormat('yyyy').format(dateTime),
  };
}
