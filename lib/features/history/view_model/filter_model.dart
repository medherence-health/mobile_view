import 'package:flutter/material.dart';
import 'package:medherence/core/model/models/drug.dart';

enum Status { all, early, late, missed }

class FilterViewModel extends ChangeNotifier {
  Status status = Status.all;
  DateTime? _selectedDate = null;
  DateTime? _secondSelectedDate = null; // Default: 1 day after selectedDate
  TextEditingController dropDownSearchController = TextEditingController();
  TextEditingController dropDownIdController = TextEditingController();
  String suggestion = "";
  String drugId = "";
  String? selectedMedication;
  List<String> regimenNames = ["opens"];
  Map<String, List<Drug?>> _groupedList = {};

  DateTime? get selectedDate => _selectedDate;
  DateTime? get secondSelectedDate => _secondSelectedDate;
  Map<String, List<Drug?>> get getGroupedList => _groupedList;

  // Method to format DateTime as "yyyy-MM-dd"
  String formatDate(DateTime? date) {
    if (date == null) {
      return "Select Date";
    }
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void setStatus(Status? value) {
    if (value != null) {
      status = value;
      notifyListeners();
    }
  }

  void setGroupedList(Map<String, List<Drug?>> value) {
    if (value != null) {
      _groupedList = value;
      notifyListeners();
    }
  }

  updateSelectedDate(DateTime? pickedDate) {
    _selectedDate = pickedDate;
    notifyListeners();
  }

  updateSecondSelectedDate(DateTime? pickedDate) {
    _secondSelectedDate = pickedDate;
    notifyListeners();
  }

  void setRegimenNames(List<String> names) {
    regimenNames = names;
    notifyListeners();
  }

  // Get suggestions based on the pattern
  List<String> getSuggestions(String pattern) {
    List<String> matches = regimenNames
        .where((s) => s.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
    return regimenNames;
  }
}
