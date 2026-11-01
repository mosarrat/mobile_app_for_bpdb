class InstalledCondition {
  int id;
  String name;

  InstalledCondition({
    required this.id,
    required this.name,
  });

  factory InstalledCondition.fromJson(Map<String, dynamic> json) {
    return InstalledCondition(
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