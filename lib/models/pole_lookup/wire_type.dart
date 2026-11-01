class WireType {
  int id;
  String name;

  WireType({
    required this.id,
    required this.name,
  });

  // Factory constructor to handle JSON parsing and null safety
  factory WireType.fromJson(Map<String, dynamic> json) {
    return WireType(
      id: json['id'] ?? 0,             // Default to 0 if null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
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
