import 'package:flutter/material.dart';

class FilterViewModel extends ChangeNotifier {
  int status = 1; // All selected by default
  DateTime _selectedDate = DateTime.now();
  DateTime _secondSelectedDate = DateTime.now()
      .add(Duration(days: 1)); // Default: 1 day after selectedDate
  TextEditingController dropDownSearchController = TextEditingController();
  String suggestion = "";
  String? selectedMedication;

  DateTime get selectedDate => _selectedDate;
  DateTime get secondSelectedDate => _secondSelectedDate;

  // Method to format DateTime as "yyyy-MM-dd"
  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  setStatus(int? value) {
    if (value != null) {
      status = value;
      notifyListeners();
    }
  }

  updateSelectedDate(DateTime pickedDate) {
    _selectedDate = pickedDate;
    debugPrint(_selectedDate.toString());
    notifyListeners();
  }

  updateSecondSelectedDate(DateTime pickedDate) {
    _secondSelectedDate = pickedDate;
    debugPrint(_secondSelectedDate.toString());
    notifyListeners();
  }

  // Replace this with your logic to fetch suggestions based on the pattern
  List<String> getSuggestions(String pattern) {
    // Implement your logic to fetch suggestions based on pattern (e.g., search from a list)
    return ["Suggestion 1", "Suggestion 2", "Suggestion 3"];
  }
}
