class Security {
  String pin;
  String type;

  Security({required this.pin, required this.type});

  // Factory constructor to create a Drug object from a Map
  factory Security.fromMap(Map<String, dynamic> map) {
    return Security(
      pin: map['pin'] ?? '',
      type: map['type'] ?? '',
    );
  }

  // Convert a Drug object to a Map
  Map<String, dynamic> toMap() {
    return {
      'pin': pin,
      'type': type,
    };
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'Security(pin: $pin,type: $type)';
  }
}
