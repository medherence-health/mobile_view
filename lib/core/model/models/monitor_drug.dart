class MonitorDrug {
  final String drug_id;
  final int time_taken;
  final int next_time_taken;
  final int cycles_left;

  MonitorDrug(
      {required this.drug_id,
      required this.time_taken,
      required this.next_time_taken,
      required this.cycles_left});

  // Factory constructor to create a Drug object from a Map
  factory MonitorDrug.fromMap(Map<String, dynamic> map) {
    return MonitorDrug(
        drug_id: map['drug_id'] ?? '',
        time_taken: map['time_taken'] ?? 0,
        next_time_taken: map['next_time_taken'] ?? 0,
        cycles_left: map['cycles_left'] ?? 0);
  }

  // Convert a Drug object to a Map
  Map<String, dynamic> toMap() {
    return {
      'drug_id': drug_id,
      'time_taken': time_taken,
      'next_time_taken': next_time_taken,
      'cycles_left': cycles_left
    };
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'MonitorDrug(drug_id: $drug_id, time_taken: $time_taken, '
        'next_time_taken: $next_time_taken, cycles_left: $cycles_left)';
  }
}
