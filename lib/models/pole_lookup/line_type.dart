class LineType {
  int lineTypeId;
  String lineTypeName;

  LineType({
    required this.lineTypeId,
    required this.lineTypeName,
  });

  // Factory constructor to handle JSON parsing and null safety
  factory LineType.fromJson(Map<String, dynamic> json) {
    return LineType(
      lineTypeId: json['lineTypeId'] ?? 0,            // Default to 0 if null
      lineTypeName: json['lineTypeName'] ?? 'Unknown', // Default to 'Unknown' if null
    );
  }

  // Method to convert this class back to JSON
  Map<String, dynamic> toJson() {
    return {
      'lineTypeId': lineTypeId,
      'lineTypeName': lineTypeName,
    };
  }
}