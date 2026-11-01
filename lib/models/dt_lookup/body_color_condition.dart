class BodyColorCondition {
  int id;
  String name;

  BodyColorCondition({
    required this.id,
    required this.name,
  });

  factory BodyColorCondition.fromJson(Map<String, dynamic> json) {
    return BodyColorCondition(
      id: json['id'] ?? 0,            // Default to 0 if null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}