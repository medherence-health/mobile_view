class Drug {
  final int adherencePercent;
  final String administrationRoute;
  final String doctorInCharge;
  final String doctorInChargeEmail;
  final String doctorInChargePhoneNumber;
  final String dosage;
  final double drugCost;
  final String drugName;
  final int drugUsageDuration;
  final String drugUsageStatus;
  final String drugUseId;
  final int drugUseNumTime;
  final int expectedDateToFinishDrug;
  final int frequencyTime;
  final String hospitalUid;
  final int maxDrugUseNumTime;
  final String medicalCondition;
  final int medicationStartDate;
  final int medicationUseDate;
  final String medicationUseIntervalFrequency;
  final String medicationsId;
  final String methodOfUse;
  final String note;
  final String nurseInCharge;
  final String nurseInChargeEmail;
  final String nurseInChargePhoneNumber;
  final int patientAge;
  final String patientName;
  final String patientUid;
  final String safety;
  String timeTaken;
  int perfectTimeToTakeDrug;
  String videoUrl;

  Drug({
    required this.adherencePercent,
    required this.administrationRoute,
    required this.doctorInCharge,
    required this.doctorInChargeEmail,
    required this.doctorInChargePhoneNumber,
    required this.dosage,
    required this.drugCost,
    required this.drugName,
    required this.drugUsageDuration,
    required this.drugUsageStatus,
    required this.drugUseId,
    required this.drugUseNumTime,
    required this.expectedDateToFinishDrug,
    required this.frequencyTime,
    required this.hospitalUid,
    required this.maxDrugUseNumTime,
    required this.medicalCondition,
    required this.medicationStartDate,
    required this.medicationUseDate,
    required this.medicationUseIntervalFrequency,
    required this.medicationsId,
    required this.methodOfUse,
    required this.note,
    required this.nurseInCharge,
    required this.nurseInChargeEmail,
    required this.nurseInChargePhoneNumber,
    required this.patientAge,
    required this.patientName,
    required this.patientUid,
    required this.safety,
    required this.timeTaken,
    required this.perfectTimeToTakeDrug,
    required this.videoUrl,
  });

  // Factory constructor to create a Drug object from a Map
  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      adherencePercent: map['adherence_percent'] ?? 0,
      administrationRoute: map['administration_route'] ?? '',
      doctorInCharge: map['doctor_in_charge'] ?? '',
      doctorInChargeEmail: map['doctor_in_charge_email'] ?? '',
      doctorInChargePhoneNumber: map['doctor_in_charge_phone_number'] ?? '',
      dosage: map['dosage'] ?? '',
      drugCost: (map['drug_cost'] ?? 0.0).toDouble(),
      drugName: map['drug_name'] ?? '',
      drugUsageDuration: map['drug_usage_duration'] ?? 0,
      drugUsageStatus: map['drug_usage_status'] ?? '',
      drugUseId: map['drug_use_id'] ?? '',
      drugUseNumTime: map['drug_use_num_time'] ?? 0,
      expectedDateToFinishDrug: map['expected_date_to_finish_drug'] ?? 0,
      frequencyTime: map['frequency_time'] ?? 0,
      hospitalUid: map['hospital_uid'] ?? '',
      maxDrugUseNumTime: map['max_drug_use_num_time'] ?? 0,
      medicalCondition: map['medical_condition'] ?? '',
      medicationStartDate: map['medication_start_date'] ?? 0,
      medicationUseDate: map['medication_use_date'] ?? 0,
      medicationUseIntervalFrequency:
          map['medication_use_interval_frequency'] ?? '',
      medicationsId: map['medications_id'] ?? '',
      methodOfUse: map['method_of_use'] ?? '',
      note: map['note'] ?? '',
      nurseInCharge: map['nurse_in_charge'] ?? '',
      nurseInChargeEmail: map['nurse_in_charge_email'] ?? '',
      nurseInChargePhoneNumber: map['nurse_in_charge_phone_number'] ?? '',
      patientAge: map['patient_age'] ?? 0,
      patientName: map['patient_name'] ?? '',
      patientUid: map['patient_uid'] ?? '',
      safety: map['safety'] ?? '',
      timeTaken: map['time_taken'] ?? '',
      perfectTimeToTakeDrug: map['perfect_time_to_take_drug'] ?? 0,
      videoUrl: map['video_url'] ?? '',
    );
  }

  // Convert a Drug object to a Map
  Map<String, dynamic> toMap() {
    return {
      'adherence_percent': adherencePercent,
      'administration_route': administrationRoute,
      'doctor_in_charge': doctorInCharge,
      'doctor_in_charge_email': doctorInChargeEmail,
      'doctor_in_charge_phone_number': doctorInChargePhoneNumber,
      'dosage': dosage,
      'drug_cost': drugCost,
      'drug_name': drugName,
      'drug_usage_duration': drugUsageDuration,
      'drug_usage_status': drugUsageStatus,
      'drug_use_id': drugUseId,
      'drug_use_num_time': drugUseNumTime,
      'expected_date_to_finish_drug': expectedDateToFinishDrug,
      'frequency_time': frequencyTime,
      'hospital_uid': hospitalUid,
      'max_drug_use_num_time': maxDrugUseNumTime,
      'medical_condition': medicalCondition,
      'medication_start_date': medicationStartDate,
      'medication_use_date': medicationUseDate,
      'medication_use_interval_frequency': medicationUseIntervalFrequency,
      'medications_id': medicationsId,
      'method_of_use': methodOfUse,
      'note': note,
      'nurse_in_charge': nurseInCharge,
      'nurse_in_charge_email': nurseInChargeEmail,
      'nurse_in_charge_phone_number': nurseInChargePhoneNumber,
      'patient_age': patientAge,
      'patient_name': patientName,
      'patient_uid': patientUid,
      'safety': safety,
      'time_taken': timeTaken,
      'perfect_time_to_take_drug': perfectTimeToTakeDrug,
      'video_url': videoUrl,
    };
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'Drug(adherence_percent: $adherencePercent, administration_route: $administrationRoute, '
        'doctor_in_charge: $doctorInCharge, doctor_in_charge_email: $doctorInChargeEmail, '
        'doctor_in_charge_phone_number: $doctorInChargePhoneNumber, dosage: $dosage, drug_cost: $drugCost, '
        'drug_name: $drugName, drug_usage_duration: $drugUsageDuration, drug_usage_status: $drugUsageStatus, '
        'drug_use_id: $drugUseId, drug_use_num_time: $drugUseNumTime, expected_date_to_finish_drug: $expectedDateToFinishDrug, '
        'frequency_time: $frequencyTime, hospital_uid: $hospitalUid, max_drug_use_num_time: $maxDrugUseNumTime, '
        'medical_condition: $medicalCondition, medication_start_date: $medicationStartDate, '
        'medication_use_date: $medicationUseDate, medication_use_interval_frequency: $medicationUseIntervalFrequency, '
        'medications_id: $medicationsId, method_of_use: $methodOfUse, note: $note, nurse_in_charge: $nurseInCharge, '
        'nurse_in_charge_email: $nurseInChargeEmail, nurse_in_charge_phone_number: $nurseInChargePhoneNumber, '
        'patient_age: $patientAge, patient_name: $patientName, patient_uid: $patientUid, safety: $safety, '
        'time_taken: $timeTaken,perfect_time_to_take_drug: $perfectTimeToTakeDrug, video_url: $videoUrl)';
  }
}
