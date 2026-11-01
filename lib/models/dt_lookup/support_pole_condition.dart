// class SupportPoleCondition {
//   int id;
//   String name;

//   SupportPoleCondition({
//     required this.id,
//     required this.name,
//   });

//   factory SupportPoleCondition.fromJson(Map<String, dynamic> json) {
//     return SupportPoleCondition(
//       id: json['id'] ?? 0,            // Default to 0 if null
//       name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }

class SupportPoleCondition {
  String id;
  String name;

  SupportPoleCondition({
    required this.id,
    required this.name,
  });

  // Factory constructor to create an SupportPoleCondition from JSON
  factory SupportPoleCondition.fromJson(Map<String, dynamic> json) {
    return SupportPoleCondition(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method to convert SupportPoleCondition instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
