class InstalledPlaced {
  int id;
  String name;

  InstalledPlaced({
    required this.id,
    required this.name,
  });

  factory InstalledPlaced.fromJson(Map<String, dynamic> json) {
    return InstalledPlaced(
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