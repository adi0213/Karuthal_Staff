class Patient {
  final int patientId;
  final String firstName;
  final String lastName;

  Patient({
    required this.patientId,
    required this.firstName,
    required this.lastName,
  });

  // Factory method to create a Patient instance from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patientId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}
