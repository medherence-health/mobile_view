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
  String status = '';

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

  Future<MedActivityResult> getMedicationActivity(String patientUid) async {
    try {
      // Query the patient_drug collection
      QuerySnapshot querySnapshot = await _firestore
          .collection('medication_activity')
          .where('patient_uid', isEqualTo: patientUid)
          // .where('drug_usage_status', isNotEqualTo: notUsed)
          .get(const GetOptions(source: Source.cache)); // Force offline cache

      // If cache is unavailable, fallback to server
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _firestore
            .collection('medication_activity')
            .where('patient_uid', isEqualTo: patientUid)
            // .where('drug_usage_status', isNotEqualTo: notUsed)
            .get(const GetOptions(source: Source.server)); // Use server data
      }

      // Convert query results into a list of Drug objects
      var listOfDrugWithoutMissedList = querySnapshot.docs
          .map((doc) => Drug.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      var completeList = completeAllList(listOfDrugWithoutMissedList);

      return completeList;
    } catch (error) {
      print("Error fetching patient drugs: $error");
      return MedActivityResult(allList: [], idMapList: {});
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
    double numberOfTimesDrugUsed = hoursBetweenMilli / drug.frequencyTime;

    return numberOfTimesDrugUsed.floor();
  }

  MissedListResult missedListGenerator(List<Drug> listOfDrugWithoutMissedList) {
    // O(n)
    if (listOfDrugWithoutMissedList.isEmpty)
      return MissedListResult(missedList: [], combinedMapList: {});

    // Get the number of times the drug should have been used
    int numberOfTimesDrugUsed =
        calculatePerfectTimeToTakeDrug(listOfDrugWithoutMissedList.first);

    // Create a map<String, Drug?> where the key is the expected time to take the drug
    Map<int, Drug?> drugMap = {};

    // Initialize the map with expected times as keys and null as values
    for (int i = 0; i < numberOfTimesDrugUsed; i++) {
      drugMap[i] = null;
    }

    // Fill the map with the actual drug usage data
    for (Drug drug in listOfDrugWithoutMissedList) {
      drugMap[drug.perfectTimeToTakeDrug] = drug;
    }

    List<Drug> missedDrugs = [];

    // Loop through the drugMap to find missed doses
    drugMap.forEach((time, drug) {
      if (drug == null) {
        var newDrug = listOfDrugWithoutMissedList.first;
        newDrug.perfectTimeToTakeDrug = time;
        newDrug.drugUsageStatus = 'missed';

        // Create a missed drug entry
        missedDrugs.add(newDrug);

        //add to drugMap for complete list
        drugMap[time] = newDrug;
      }
    });

    return MissedListResult(missedList: missedDrugs, combinedMapList: drugMap);
  }

  Map<String, List<Drug>> groupListByMedId(
      List<Drug> listOfDrugWithoutMissedList) {
    // O(n)
    Map<String, List<Drug>> drugMap = {};

    for (Drug drug in listOfDrugWithoutMissedList) {
      drugMap.putIfAbsent(drug.medicationsId, () => []).add(drug);
    }

    return drugMap;
  }

  MedActivityResult completeAllList(List<Drug> listOfDrugWithoutMissedList) {
    Map<String, List<Drug?>> filterStatus = {};

    // Group List
    var groupedList = groupListByMedId(listOfDrugWithoutMissedList);

    Map<String, List<Drug?>> combinedMapList = {};
    Map<String, List<Drug?>> missedDrugsList = {};
    List<Drug?> allList = [];

    groupedList.forEach((id, list) {
      var missedListRes = missedListGenerator(list);
      missedDrugsList[id] = missedListRes.missedList;
      combinedMapList[id] = missedListRes.combinedMapList.values.toList();

      allList.addAll(list);
    });

    // // filter by status
    // if (model.status != Status.all) {
    //   for (Drug? drug in allList) {
    //     filterStatus[drug?.drugUsageStatus.toLowerCase()]?.add(drug);
    //   }
    //   // filterStatus[model.status.toString().toLowerCase()];
    // }
    //
    // // filter by date
    // if (model.selectedDate != null || model.secondSelectedDate != null) {
    //   List<Drug?> filteredDateList = [];
    //   for (Drug? drug in allList) {
    //     if (model.selectedDate != null &&
    //         drug!.medicationUseDate >=
    //             model.selectedDate!.millisecondsSinceEpoch) {
    //       // From date
    //       filteredDateList.add(drug);
    //     }
    //     if (model.secondSelectedDate != null &&
    //         drug!.medicationUseDate <=
    //             model.secondSelectedDate!.millisecondsSinceEpoch) {
    //       // To date
    //       filteredDateList.add(drug);
    //     }
    //   }
    //   // filterStatus[model.status.toString().toLowerCase()];
    // }
    return MedActivityResult(allList: allList, idMapList: groupedList);
  }
}

class ListDrugPercent {
  final List<Drug> listOfDrugs;
  final int percent;
  ListDrugPercent({required this.listOfDrugs, required this.percent});
}

class MissedListResult {
  final List<Drug> missedList;
  final Map<int, Drug?> combinedMapList;
  MissedListResult({required this.missedList, required this.combinedMapList});
}

class MedActivityResult {
  final List<Drug?> allList;
  final Map<String, List<Drug?>> idMapList;
  MedActivityResult({required this.allList, required this.idMapList});
}
