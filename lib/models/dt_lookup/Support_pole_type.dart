class SupportPoleType {
  int id;
  String name;

  SupportPoleType({
    required this.id,
    required this.name,
  });

  factory SupportPoleType.fromJson(Map<String, dynamic> json) {
    return SupportPoleType(
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