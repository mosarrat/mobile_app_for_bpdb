class TransformerDetails {
  int id;
  String? distributionTransformerCode;
  int? poleDetailsLeftId;
  int? poleDetailsRightId;
  String? dtLocationName; // Added field for location name

  TransformerDetails({
    required this.id,
    this.distributionTransformerCode,
    this.poleDetailsLeftId,
    this.poleDetailsRightId,
    this.dtLocationName,
  });

  // Factory constructor to create a TransformerDetails instance from JSON
  factory TransformerDetails.fromJson(Map<String, dynamic> json) {
    return TransformerDetails(
      id: json['id'],
      distributionTransformerCode: json['distributionTransformerCode'],
      poleDetailsLeftId: json['poleDetailsLeftId'],
      poleDetailsRightId: json['poleDetailsRightId'],
      dtLocationName: json['dtLocationName'], // Initialize location name from JSON
    );
  }

  // Method to convert a TransformerDetails instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributionTransformerCode': distributionTransformerCode,
      'poleDetailsLeftId': poleDetailsLeftId,
      'poleDetailsRightId': poleDetailsRightId,
      'dtLocationName': dtLocationName, // Include location name in JSON
    };
  }
}
