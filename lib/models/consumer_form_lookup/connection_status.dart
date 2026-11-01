class ConnectionStatus {
  final int connectionStatusId;
  final String connectionStatusName;

  ConnectionStatus({
    required this.connectionStatusId,
    required this.connectionStatusName,
  });

  factory ConnectionStatus.fromJson(Map<String, dynamic> json) {
    return ConnectionStatus(
      connectionStatusId: json['connectionStatusId'],
      connectionStatusName: json['connectionStatusName'],
    );
  }
  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'connectionStatusId': connectionStatusId,
      'connectionStatusName': connectionStatusName,
    };
  }
}