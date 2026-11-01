class ConnectionType {
  final int connectionTypeId;
  final String connectionTypeName;

  ConnectionType({
    required this.connectionTypeId,
    required this.connectionTypeName,
  });

  factory ConnectionType.fromJson(Map<String, dynamic> json) {
    return ConnectionType(
      connectionTypeId: json['connectionTypeId'],
      connectionTypeName: json['connectionTypeName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'connectionTypeId': connectionTypeId,
      'connectionTypeName': connectionTypeName,
    };
  }
}