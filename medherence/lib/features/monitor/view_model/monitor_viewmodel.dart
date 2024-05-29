import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

class MedicationAdherenceViewModel extends ChangeNotifier {
  // Properties
  // final CameraService? cameraService; // Inject CameraService if used
  bool isScanning = false;
  bool isMedicationDetected = false;
  bool isMedicationUsed = false;

  // Functions
  void startScan() {
    isScanning = true;
    // Logic to start camera and AI analysis (using CameraService or directly)
    notifyListeners();
  }

  void medicationDetected() {
    isMedicationDetected = true;
    notifyListeners();
  }

  void medicationUsed() {
    isMedicationUsed = true;
    notifyListeners();
  }

  void finishScan() {
    isScanning = false;
    isMedicationDetected = false;
    isMedicationUsed = false;
    // Logic to stop camera and AI analysis
    notifyListeners();
  }
}
