class College {
  final int id;
  final String name;

  College({required this.id, required this.name});

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return '$name (ID: $id)';
  }

  // Define a static list of colleges
  static List<College> get values => [
        College(id: 1, name: 'College A'),
        College(id: 2, name: 'College B'),
        College(id: 3, name: 'College C'),
        // Add more colleges as needed
      ];
}
