import 'package:flutter/material.dart';

class FilterViewModel extends ChangeNotifier {
  int status = 1; // All selected by default
  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay _secondSelectedTime = TimeOfDay.now().replacing(
      hour: (TimeOfDay.now().hour + 1) %
          24); // Default: 1 hour after selectedTime
  TextEditingController dropDownSearchController = TextEditingController();
  String suggestion = "";
  String? selectedMedication;

  TimeOfDay get lastTime => _secondSelectedTime;
  TimeOfDay get firstTime => _selectedTime;

  // Method to format TimeOfDay as "yyyy-MM-dd"
  String formatTimeOfDay(TimeOfDay time) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Create a DateTime object with the same date as currentDate and the time from the TimeOfDay object
    DateTime dateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      time.hour,
      time.minute,
    );

    // Format the DateTime object as "yyyy-MM-dd"
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  setStatus(int? value) {
    status = value!;
  }

  updateSelectedTime(TimeOfDay pickedTime) {
    _selectedTime = pickedTime;
    notifyListeners();
  }

  updateSecondSelectedTime(TimeOfDay pickedTime) {
    _secondSelectedTime = pickedTime;
    notifyListeners();
  }

  // Replace this with your logic to fetch suggestions based on the pattern
  List<String> getSuggestions(String pattern) {
    // Implement your logic to fetch suggestions based on pattern (e.g., search from a list)
    return ["Suggestion 1", "Suggestion 2", "Suggestion 3"];
  }
}
