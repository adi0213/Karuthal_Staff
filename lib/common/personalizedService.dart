class PersonalizedService {
  final int id; // Assuming you have an id
  final String name;

  PersonalizedService({required this.id, required this.name});

  factory PersonalizedService.fromJson(Map<String, dynamic> json) {
    return PersonalizedService(
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalizedService &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
