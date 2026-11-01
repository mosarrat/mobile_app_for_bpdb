class MeterType {
  final int meterTypeId;
  final String meterTypeName;

  MeterType({
    required this.meterTypeId,
    required this.meterTypeName,
  });

  factory MeterType.fromJson(Map<String, dynamic> json) {
    return MeterType(
      meterTypeId: json['meterTypeId'],
      meterTypeName: json['meterTypeName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'meterTypeId': meterTypeId,
      'meterTypeName': meterTypeName,
    };
  }
}