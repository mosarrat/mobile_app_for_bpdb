class BusinessType {
  final int businessTypeId;
  final String businessTypeName;

  BusinessType({
    required this.businessTypeId,
    required this.businessTypeName,
  });

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    return BusinessType(
      businessTypeId: json['businessTypeId'],
      businessTypeName: json['businessTypeName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'businessTypeId': businessTypeId,
      'businessTypeName': businessTypeName,
    };
  }
}