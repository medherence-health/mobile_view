class Progress {
  final int progress;

  Progress({required this.progress});

  // Factory constructor to create a Drug object from a Map
  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      progress: map['progress'] ?? '',
    );
  }

  // Convert a Drug object to a Map
  Map<String, dynamic> toMap() {
    return {
      'progress': progress,
    };
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'Progress(progress: $progress)';
  }
}
