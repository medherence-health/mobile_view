import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medherence/core/constants/constants.dart';
import 'package:medherence/core/database/database_service.dart';
import 'package:medherence/core/model/models/drug.dart';
import 'package:medherence/core/model/models/monitor_drug.dart';
import 'package:medherence/core/model/models/progress.dart';
import 'package:medherence/core/model/models/user_data.dart';
import 'package:medherence/core/service/notification_service.dart';

import '../../../core/utils/image_utils.dart';

class ProfileViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nicknameController = TextEditingController();
  TextEditingController nokFirstNameController = TextEditingController();
  TextEditingController nokLastNameController = TextEditingController();
  TextEditingController nokPhoneNumberController = TextEditingController();
  TextEditingController nokRelationController = TextEditingController();
  Color? nicknameFillColor = Colors.white70;
  Color? nokFirstFillColor = Colors.white70;
  Color? nokLastFillColor = Colors.white70;
  Color? nokPhoneFillColor = Colors.white70;
  Color? nokRelationFillColor = Colors.white70;
  int gender = 1; // Default to Male
  bool isFormValid = false;
  String selectedAvatar = '';
  String nickName = '';

  ProfileViewModel() {
    nicknameController = TextEditingController();
    nokFirstNameController = TextEditingController();
    nokLastNameController = TextEditingController();
    nokPhoneNumberController = TextEditingController();
    nokRelationController = TextEditingController();
    selectedAvatar = ImageUtils.avatar4; // Default avatar
    nickName = 'ADB';
  }

  Future<ProgressResult> getProgress() async {
    var progress = await _databaseService.getProgress();

    return progress;
  }

  Future<List<Drug>> getPatientDrugs(String patientUid) async {
    try {
      // Query the patient_drug collection
      QuerySnapshot querySnapshot = await _firestore
          .collection('patient_drug')
          .where('patient_uid', isEqualTo: patientUid)
          .get(const GetOptions(source: Source.cache)); // Force offline cache

      // If cache is unavailable, fallback to server
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _firestore
            .collection('patient_drug')
            .where('patient_uid', isEqualTo: patientUid)
            .get(const GetOptions(source: Source.server)); // Use server data
      }

      // Convert query results into a list of Drug objects
      return querySnapshot.docs
          .map((doc) => Drug.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print("Error fetching patient drugs: $error");
      return [];
    }
  }

  Future<ListDrugPercent> getPatientTodayDrugs(String patientUid) async {
    List<Drug> filteredDrugList = [];
    int usedCount = 0;
    int notUsedCount = 0;
    int totalCount = 0;
    int percentageOfUsed = 0;

    try {
      print('currentTimeInMilli$currentTimeInMilli');
      // Query the patient_drug collection
      QuerySnapshot querySnapshot = await _firestore
          .collection('patient_drug')
          .where('patient_uid', isEqualTo: patientUid)
          // .where('expected_date_to_finish_drug',
          //     isGreaterThanOrEqualTo: currentTimeInMilli)
          .get(const GetOptions(source: Source.cache)); // Force offline cache

      // If cache is unavailable, fallback to server
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _firestore
            .collection('patient_drug')
            .where('patient_uid', isEqualTo: patientUid)
            // .where('expected_date_to_finish_drug',
            //     isGreaterThanOrEqualTo: currentTimeInMilli)
            .get(const GetOptions(source: Source.server)); // Use server data
      }

      // Convert query results into a list of Drug objects
      var firestoreData = querySnapshot.docs
          .map((doc) => Drug.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      for (Drug drug in firestoreData) {
        var monitoredDataResult = await _databaseService
            .getMonitorDrugById(firestoreData.first.medicationsId);

        if (monitoredDataResult.monitorDrug == null) {
          filteredDrugList.add(drug);
        } else {
          // check if drug has been used
          if (monitoredDataResult.monitorDrug!.next_time_taken <=
                  currentTimeInMilli &&
              drug.medicationUseDate <= currentTimeInMilli) {
            filteredDrugList.add(drug);
          }
        }

        //set alarm for each drug
        var notificationService = NotificationService();
        notificationService.scheduleNotification(drug);
      }

      notUsedCount = filteredDrugList.length;
      totalCount = firestoreData.length;
      usedCount = notUsedCount - totalCount;
      percentageOfUsed = ((usedCount / totalCount) * 100) as int;

      await _databaseService
          .insertProgress(Progress(progress: percentageOfUsed));

      return ListDrugPercent(
          listOfDrugs: filteredDrugList, percent: percentageOfUsed);
    } catch (error) {
      print("Error fetching patient drugs: $error");
      return ListDrugPercent(listOfDrugs: [], percent: 0);
    }
  }

  Future<List<Drug>> getMedicationActivity(String patientUid) async {
    try {
      // Query the patient_drug collection
      QuerySnapshot querySnapshot = await _firestore
          .collection('medication_activity')
          .where('patient_uid', isEqualTo: patientUid)
          .get(const GetOptions(source: Source.cache)); // Force offline cache

      // If cache is unavailable, fallback to server
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _firestore
            .collection('patient_drug')
            .where('patient_uid', isEqualTo: patientUid)
            .get(const GetOptions(source: Source.server)); // Use server data
      }

      // Convert query results into a list of Drug objects
      return querySnapshot.docs
          .map((doc) => Drug.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print("Error fetching patient drugs: $error");
      return [];
    }
  }

  Future<String> setMedicationActivity(List<Drug> selectedDrugList) async {
    try {
      // Create a batch for Firestore operations
      WriteBatch batch = _firestore.batch();

      // Add each drug to the batch
      for (Drug drug in selectedDrugList) {
        drug.timeTaken = currentTimeInMilli.toString();
        drug.perfectTimeToTakeDrug = calculatePerfectTimeToTakeDrug(drug);

        DocumentReference docRef =
            _firestore.collection('medication_activity').doc();

        // Reference for patient drug update
        DocumentReference docRefPatientDrug =
            _firestore.collection('patient_drug').doc(drug.medicationsId);

        batch.set(docRef, drug.toMap());
        batch.update(
            docRefPatientDrug, {"medication_use_date": currentTimeInMilli});
      }

      // Commit the batch
      await batch.commit();

      // After successful commit, update local database
      for (Drug drug in selectedDrugList) {
        await updateMonitorDrug(drug);
      }

      return ok;
    } catch (e) {
      // Log the error (use a logging library if available)
      print("Error updating medication activity: $e");

      // Return a user-friendly error message
      return "Error: $e";
    }
  }

  Future<String> updateMonitorDrug(Drug drug) async {
    int next_time_taken = addHoursToCurrentMillis(
        drug.frequencyTime); // next time drug should be taken

    int cycles_left = cyclesLeftUntil(drug.expectedDateToFinishDrug,
        drug.frequencyTime); // amount of drugs left to be taken

    //create the MonitorDrug
    MonitorDrug monitorDrug = MonitorDrug(
        drug_id: drug.medicationsId,
        time_taken: int.tryParse(drug.timeTaken) ?? currentTimeInMilli,
        next_time_taken: next_time_taken,
        cycles_left: cycles_left);

    var result = await _databaseService.getMonitorDrugById(monitorDrug.drug_id);
    if (result.monitorDrug == null) {
      // insert into database
      await _databaseService.insertMonitorDrug(monitorDrug);
      return ok;
    } else {
      await _databaseService.updateMonitorDrug(monitorDrug);
      return ok;
    }
  }

  Future<String> setMedicationActivityVideo(
      List<Drug> selectedDrugList, String downloadUrl) async {
    try {
      // Create a batch for Firestore operations
      WriteBatch batch = _firestore.batch();

      // Add each drug to the batch
      for (Drug drug in selectedDrugList) {
        drug.timeTaken = currentTimeInMilli.toString();
        drug.videoUrl = downloadUrl;
        DocumentReference docRef =
            _firestore.collection('medication_activity').doc();
        batch.set(docRef, drug.toMap());
      }

      // Commit the batch
      await batch.commit();

      return ok;
    } catch (e) {
      // Log the error (use a logging library if available)
      print("Error updating medication activity: $e");

      // Return a user-friendly error message
      return "Error: $e";
    }
  }

  void setAvatar(String avatar) {
    selectedAvatar = avatar;
    notifyListeners();
  }

  void setNickName(String name) {
    nickName = name;
    notifyListeners();
  }

  void setGender(int? value) {
    if (value != null) {
      gender = value;
      notifyListeners();
      _validateForm();
    }
  }

  Future<UserData?> getUserData() async {
    var result =
        await _databaseService.getUserDataById(_auth.currentUser?.uid ?? "");

    return result.userData;
  }

  void _validateForm() {
    if (gender != 0 &&
        nokFirstNameController.text.isNotEmpty &&
        nokLastNameController.text.isNotEmpty &&
        nokPhoneNumberController.text.isNotEmpty &&
        nokRelationController.text.isNotEmpty) {
      isFormValid = true;
    } else {
      isFormValid = false;
    }
    notifyListeners();
  }

  void saveProfile(BuildContext context) {
    // Perform form validation
    if (isFormValid) {
      // Show successful toast message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );

      // Redirect to DashboardView
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => DashboardView()),
      // );
    }
  }

  int calculatePerfectTimeToTakeDrug(Drug drug) {
    // using current time and time start time to check get how many hours should have passed
    var hoursBetweenMilli =
        getHoursBetween(drug.medicationStartDate, currentTimeInMilli);

    // hours passed divided by freq get the number before the decimal
    double timesPassed = hoursBetweenMilli / drug.frequencyTime;

    return timesPassed.floor();
  }
}

class ListDrugPercent {
  final List<Drug> listOfDrugs;
  final int percent;
  ListDrugPercent({required this.listOfDrugs, required this.percent});
}
