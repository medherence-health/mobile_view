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
