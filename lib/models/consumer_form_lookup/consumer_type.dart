class ConsumerType {
  final int consumerTypeId;
  final String consumerTypeName;

  ConsumerType({
    required this.consumerTypeId,
    required this.consumerTypeName,
  });

  factory ConsumerType.fromJson(Map<String, dynamic> json) {
    return ConsumerType(
      consumerTypeId: json['consumerTypeId'],
      consumerTypeName: json['consumerTypeName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'consumerTypeId': consumerTypeId,
      'consumerTypeName': consumerTypeName,
    };
  }
}