class SurviceCableType {
  final int serviceCableTypeId;
  final String serviceCableTypeName;

  SurviceCableType({
    required this.serviceCableTypeId,
    required this.serviceCableTypeName,
  });

  factory SurviceCableType.fromJson(Map<String, dynamic> json) {
    return SurviceCableType(
      serviceCableTypeId: json['serviceCableTypeId'],
      serviceCableTypeName: json['serviceCableTypeName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'serviceCableTypeId': serviceCableTypeId,
      'serviceCableTypeName': serviceCableTypeName,
    };
  }
}