class PlatfromMeterial {
  int id;
  String name;

  PlatfromMeterial({
    required this.id,
    required this.name,
  });

  factory PlatfromMeterial.fromJson(Map<String, dynamic> json) {
    return PlatfromMeterial(
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