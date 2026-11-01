class ConsumerUpdate {
  final int consumerId;
  final String consumerNo;
  final int substationId;
  final int feederLineId;
  final int servicesPointId;
  final int? dtId;
  final String customerName;
  final String? customerNameBng;
  final String? fatherName;
  final String? customerNid;
  final String mobileNo;
  final String? email;
  final String customerAddress;
  final int? meterTypeId;
  final String meterModel;
  final String meterNumber;
  final String meterManufacturer;
  final int? phasingCodeTypeId;
  final int? locationId;
  final double? omfKwh;
  double? latitude;
  double? longitude;

  ConsumerUpdate({
    required this.consumerId,
    required this.consumerNo,
    required this.substationId,
    required this.feederLineId,
    required this.servicesPointId,
    this.dtId,
    required this.customerName,
    this.customerNameBng,
    this.fatherName,
    this.customerNid,
    required this.mobileNo,
    this.email,
    required this.customerAddress,
    this.meterTypeId,
    required this.meterModel,
    required this.meterNumber,
    required this.meterManufacturer,
    this.phasingCodeTypeId,
    this.locationId,
    this.omfKwh,
    this.latitude,
    this.longitude,
  });

  factory ConsumerUpdate.fromJson(Map<String, dynamic> json) {
    return ConsumerUpdate(
      consumerId: json['consumerId'],
      consumerNo: json['consumerNo'],
      substationId: json['substationId'],
      feederLineId: json['feederLineId'],
      servicesPointId: json['servicesPointId'],
      dtId: json['dtId'],
      customerName: json['customerName'],
      customerNameBng: json['customerNameBng'],
      fatherName: json['fatherName'],
      customerNid: json['customerNid'],
      mobileNo: json['mobileNo'],
      email: json['email'],
      customerAddress: json['customerAddress'],
      meterTypeId: json['meterTypeId'],
      meterModel: json['meterModel'],
      meterNumber: json['meterNumber'],
      meterManufacturer: json['meterManufacturer'],
      phasingCodeTypeId: json['phasingCodeTypeId'],
      locationId: json['locationId'],
      // omfKwh: (json['omfKwh'] ?? 0).toDouble(),
      // latitude: (json['latitude'] ?? 0).toDouble(),
      // longitude: (json['longitude'] ?? 0).toDouble(),
      omfKwh: (json['omfKwh'] as num?)?.toDouble() ?? 0.0,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consumerId': consumerId,
      'consumerNo': consumerNo,
      'substationId': substationId,
      'feederLineId': feederLineId,
      'servicesPointId': servicesPointId,
      'dtId': dtId,
      'customerName': customerName,
      'customerNameBng': customerNameBng,
      'fatherName': fatherName,
      'customerNid': customerNid,
      'mobileNo': mobileNo,
      'email': email,
      'customerAddress': customerAddress,
      'meterTypeId': meterTypeId,
      'meterModel': meterModel,
      'meterNumber': meterNumber,
      'meterManufacturer': meterManufacturer,
      'phasingCodeTypeId': phasingCodeTypeId,
      'locationId': locationId,
      'omfKwh': omfKwh,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
