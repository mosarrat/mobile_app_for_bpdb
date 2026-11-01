class Locations {
  final int locationId;
  final String locationName;

  Locations({
    required this.locationId,
    required this.locationName,
  });

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      locationId: json['locationId'],
      locationName: json['locationName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'locationName': locationName,
    };
  }
}