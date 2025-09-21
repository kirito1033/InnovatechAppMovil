class Ciudad {
  final int id;
  final String code;
  final String name;
  final String department;

  Ciudad({
    required this.id,
    required this.code,
    required this.name,
    required this.department,
  });

  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return Ciudad(
      id: json['id'],
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      department: json['department'] ?? '',
    );
  }
}
