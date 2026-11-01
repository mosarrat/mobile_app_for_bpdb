class SagCondition {
  String id;
  String name;

  SagCondition({
    required this.id,
    required this.name,
  });

  // Factory constructor to handle JSON parsing and null safety
  factory SagCondition.fromJson(Map<String, dynamic> json) {
    return SagCondition(
      id: json['id'] ?? 'Unknown',      // Default to 'Unknown' if null
      name: json['name'] ?? 'Unnamed',   // Default to 'Unnamed' if null
    );
  }

  // Method to convert this class back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

