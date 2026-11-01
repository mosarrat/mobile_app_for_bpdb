class ConsumerInfo {
  final int consumerId;
  final int feederLineId;
  final int servicesPointId;
  final String customerName;
  final String meterNumber;
  final String? fatherName; // Nullable field
  final String? mobileNo; // Nullable field
  final String? email; // Nullable field
  final String consumerNo;

  ConsumerInfo({
    required this.consumerId,
    required this.feederLineId,
    required this.servicesPointId,
    required this.customerName,
    required this.meterNumber,
    this.fatherName,
    this.mobileNo,
    this.email,
    required this.consumerNo,
  });

  // Factory constructor to create an instance from JSON
  factory ConsumerInfo.fromJson(Map<String, dynamic> json) {
    return ConsumerInfo(
      consumerId: json['consumerId'],
      feederLineId: json['feederLineId'],
      servicesPointId: json['servicesPointId'],
      customerName: json['customerName'],
      meterNumber: json['meterNumber'],
      fatherName: json['fatherName'],
      mobileNo: json['mobileNo'],
      email: json['email'],
      consumerNo: json['consumerNo'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'consumerId': consumerId,
      'feederLineId': feederLineId,
      'servicesPointId': servicesPointId,
      'customerName': customerName,
      'meterNumber': meterNumber,
      'fatherName': fatherName,
      'mobileNo': mobileNo,
      'email': email,
      'consumerNo': consumerNo,
    };
  }
}