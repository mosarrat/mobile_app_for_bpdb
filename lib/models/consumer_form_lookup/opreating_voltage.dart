class OperatingVoltage {
  final int operatingVoltageId;
  final String operatingVoltageName;

  OperatingVoltage({
    required this.operatingVoltageId,
    required this.operatingVoltageName,
  });

  factory OperatingVoltage.fromJson(Map<String, dynamic> json) {
    return OperatingVoltage(
      operatingVoltageId: json['operatingVoltageId'],
      operatingVoltageName: json['operatingVoltageName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'operatingVoltageId': operatingVoltageId,
      'operatingVoltageName': operatingVoltageName,
    };
  }
}