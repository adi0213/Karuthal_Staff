class Student {
  final int studentId;
  final String firstName;
  final String lastName;
  final String email;
  final String username;

  Student({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
  });

  // Factory method to create a Student instance from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'] ?? 0,
      firstName: json['registeredUser'] != null
          ? json['registeredUser']['firstName'] ?? ''
          : 'Unknown',
      lastName: json['registeredUser'] != null
          ? json['registeredUser']['lastName'] ?? ''
          : '',
      email: json['registeredUser'] != null
          ? json['registeredUser']['email'] ?? 'N/A'
          : 'N/A',
      username: json['registeredUser'] != null
          ? json['registeredUser']['username'] ?? 'N/A'
          : 'N/A',
    );
  }
}
