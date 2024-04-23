import 'package:flutter/material.dart';

import '../../../core/model/models/history_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';

class ReminderState extends ChangeNotifier {
  List<HistoryModel> _regimenList = generateSimulatedData();
  bool _val = true;
  bool _pillCount = false;
  String _selectedSound = 'Aegean Sea'; // Default sound
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isAlarmOn = true;

  List<HistoryModel> get regimenList => _regimenList;
  bool get val => _val;
  bool get pillCount => _pillCount;
  String get selectedSound => _selectedSound;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isAlarmOn => _isAlarmOn;
  Map<int, bool> _checkedMap = {}; // Map to store checked status of regimens

  // Method to get the number of checked regimens
  int getCheckedCount() {
    int count = 0;
    for (var i = 0; i < _regimenList.length; i++) {
      if (_checkedMap.containsKey(i) && _checkedMap[i]!) {
        count++;
      }
    }
    return count;
  }

  // Method to check if a regimen at a specific index is checked
  bool isChecked(HistoryModel regimen) {
    int index = _regimenList.indexOf(regimen);
    return _checkedMap[index] ?? false;
  }

  // Method to toggle the checked status of a regimen at a specific index
  void toggleChecked(HistoryModel regimen) {
    int index = _regimenList.indexOf(regimen);
    bool isChecked = _checkedMap[index] ?? false;
    _checkedMap[index] = !isChecked;
    notifyListeners();
  }

  void updateRegimenList(List<HistoryModel> updatedList) {
    _regimenList = updatedList;
    notifyListeners();
  }

  void updateVal(bool newVal) {
    _val = newVal;
    notifyListeners();
  }

  void updatePillCount(bool newPillCount) {
    _pillCount = newPillCount;
    notifyListeners();
  }

  void updateSelectedSound(String newSound) {
    _selectedSound = newSound;
    notifyListeners();
  }

  void updateSelectedTime(TimeOfDay newTime) {
    _selectedTime = newTime;
    notifyListeners();
  }

  void updateIsAlarmOn(bool newIsAlarmOn) {
    _isAlarmOn = newIsAlarmOn;
    notifyListeners();
  }
}
