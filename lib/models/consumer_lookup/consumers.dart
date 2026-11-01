class Consumers {
  final int consumerId;
  final String consumerNo;
  final int servicesPointId;
  final int zoneId;
  final int circleId;
  final int sndId;
  final int? esuId;
  final int? dtId;
  final int poleDetailsId;
  final int feederLineId;
  final int substationId;
  final int? feederUId;
  final String customerName;
  final String? customerNameBng;
  final String? customerNid;
  final String? fatherName;
  final String? mobileNo;
  final String? email;
  final int? tariffCategoryId;
  final int? tariffSubCategoryId;
  final String? tariff; 
  final int? phasingCodeTypeId;
  final int? consumerTypeId;
  final int? operatingVoltageId;
  final String installDate;
  final int? connectionStatusId;
  final int? connectionTypeId;
  final int? meterTypeId;
  final String? meterNumber;
  final String? meterModel;
  final String? meterManufacturer;
  final double? sanctionedLoad;
  final double? connectedLoad;
  final int? businessTypeId;
  final String? othersBusiness;
  final String? accountNumber;
  final String? specialCode;
  final String? specialType;
  final int? locationId;
  final String? billGroup; 
  final String? bookNumber;
  final double? omfKwh;
  final double? meterReading; 
  final int? serviceCableSize;
  final int? serviceCableTypeId;
  final String? customerAddress;
  final String? unionGeoCode;
  final String? union;
  final String? plotNo;
  final String? buildingAptNo;
  final String? premiseName;
  final String? surveyDate;
  final double? latitude;
  final double? longitude;
  final String? structureId;
  final String? structureMapNo;
  final int? structureTypeId;
  final dynamic consumerToStructureType; 
  final int? numberOfFloor;
  final dynamic distanceFromSp; 
  final String startingDate;
  final DateTime? endingDate;
  final int activationStatusId;
  final dynamic dataActivationStatus; 
  final int verificationStateId;
  final int distance_from_sp;
  final dynamic dataVerificationState; 
  final String remarks;

  Consumers({
    required this.consumerId,
    required this.consumerNo,
    required this.servicesPointId,
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    this.esuId,
    this.dtId,
    required this.poleDetailsId,
    required this.feederLineId,
    required this.substationId,
    this.feederUId,
    required this.customerName,
    this.customerNameBng,
    this.customerNid,
    this.fatherName,
    this.mobileNo,
    this.email,
    this.tariffCategoryId,
    this.tariffSubCategoryId,
    this.tariff,
    this.phasingCodeTypeId,
    this.consumerTypeId,
    this.operatingVoltageId,
    required this.installDate,
    this.connectionStatusId,
    this.connectionTypeId,
    this.meterTypeId,
    this.meterNumber,
    this.meterModel,
    this.meterManufacturer,
    this.sanctionedLoad,
    this.connectedLoad,
    this.businessTypeId,
    this.othersBusiness,
    this.accountNumber,
    this.specialCode,
    this.specialType,
    this.locationId,
    this.billGroup,
    this.bookNumber,
    this.omfKwh,
    this.meterReading,
    this.serviceCableSize,
    this.serviceCableTypeId,
    this.customerAddress,
    this.unionGeoCode,
    this.union,
    this.plotNo,
    this.buildingAptNo,
    this.premiseName,
    this.surveyDate,
    this.latitude,
    this.longitude,
    this.structureId,
    this.structureMapNo,
    this.structureTypeId,
    this.consumerToStructureType,
    this.numberOfFloor,
    this.distanceFromSp,
    required this.startingDate,
    this.endingDate,
    required this.activationStatusId,
    this.dataActivationStatus,
    required this.verificationStateId,
    required this.distance_from_sp,
    this.dataVerificationState,
    required this.remarks,
  });

  factory Consumers.fromJson(Map<String, dynamic> json) {
  return Consumers(
      consumerId: json['consumerId'] ?? 0,
      consumerNo: json['consumerNo']?.toString() ?? '',
      servicesPointId: json['servicesPointId'] ?? 0,
      zoneId: json['zoneId'] ?? 0,
      circleId: json['circleId'] ?? 0,
      sndId: json['sndId'] ?? 0,
      esuId: json['esuId'] ?? 0,
      dtId: json['dtId'] ?? 0,
      poleDetailsId: json['poleDetailsId'] ?? 0,
      feederLineId: json['feederLineId'] ?? 0,
      substationId: json['substationId'] ?? 0,
      feederUId: json['feederUId'] ?? 0, 
      customerName: json['customerName'] ?? '',
      customerNameBng: json['customerNameBng'] ?? '',
      customerNid: json['customerNid'] ?? '',
      fatherName: json['fatherName'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      email: json['email'] ?? '',
      tariffCategoryId: json['tariffCategoryId'] ?? 0, 
      tariffSubCategoryId: json['tariffSubCategoryId'] ?? 0, 
      tariff: json['tariff'] ?? '', 
      phasingCodeTypeId: json['phasingCodeTypeId'] ?? 0, 
      consumerTypeId: json['consumerTypeId'] ?? 0, 
      operatingVoltageId: json['operatingVoltageId'] ?? 0,
      installDate: json['installDate'] ?? '',
      connectionStatusId: json['connectionStatusId'] ?? 0, 
      connectionTypeId: json['connectionTypeId'] ?? 0, 
      meterTypeId: json['meterTypeId'] ?? 0, 
      meterNumber: json['meterNumber'] ?? '',
      meterModel: json['meterModel'] ?? '',
      meterManufacturer: json['meterManufacturer'] ?? '',
      sanctionedLoad: (json['sanctionedLoad'] ?? 0.0).toDouble(),
      connectedLoad: (json['connectedLoad'] ?? 0.0).toDouble(),
      businessTypeId: json['businessTypeId'] ?? 0, 
      othersBusiness: json['othersBusiness'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      specialCode: json['specialCode'] ?? '', 
      specialType: json['specialType'] ?? '', 
      locationId: json['locationId'] ?? 0, 
      billGroup: json['billGroup'] ?? '', 
      bookNumber: json['bookNumber'] ?? '', 
      omfKwh: (json['omfKwh'] ?? 0.0).toDouble(), 
      meterReading: (json['meterReading'] ?? 0.0).toDouble(), 
      serviceCableSize: json['serviceCableSize'] ?? 0, 
      serviceCableTypeId: json['serviceCableTypeId'] ?? 0, 
      customerAddress: json['customerAddress'] ?? '',
      unionGeoCode: json['unionGeoCode'] ?? '',
      union: json['union'] ?? '',
      plotNo: json['plotNo'] ?? '',
      buildingAptNo: json['buildingAptNo'] ?? '',
      premiseName: json['premiseName'] ?? '',
      surveyDate: json['surveyDate'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      structureId: json['structureId'] ?? '',
      structureMapNo: json['structureMapNo'] ?? '',
      structureTypeId: json['structureTypeId'] ?? 0, 
      consumerToStructureType: json['consumerToStructureType'] ?? '',
      numberOfFloor: json['numberOfFloor'] ?? 0,
      distanceFromSp: (json['distanceFromSp'] ?? 0.0).toDouble(),
      startingDate: json['startingDate'] ?? '',
      endingDate: json['endingDate'] != null ? DateTime.parse(json['endingDate']) : null,
      activationStatusId: json['activationStatusId'] ?? 0, 
      dataActivationStatus: json['dataActivationStatus'] ?? '',
      verificationStateId: json['verificationStateId'] ?? 0, 
      distance_from_sp: json['distance_from_sp'] ?? 0,
      dataVerificationState: json['dataVerificationState'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consumerId': consumerId,
      'consumerNo': consumerNo,
      'servicesPointId': servicesPointId,
      'zoneId': zoneId,
      'circleId': circleId,
      'sndId': sndId,
      'esuId': esuId,
      'dtId': dtId,
      'poleDetailsId': poleDetailsId,
      'feederLineId': feederLineId,
      'substationId': substationId,
      'feederUId': feederUId,
      'customerName': customerName,
      'customerNameBng': customerNameBng,
      'customerNid': customerNid,
      'fatherName': fatherName,
      'mobileNo': mobileNo,
      'email': email,
      'tariffCategoryId': tariffCategoryId,
      'tariffSubCategoryId': tariffSubCategoryId,
      'tariff': tariff,
      'phasingCodeTypeId': phasingCodeTypeId,
      'consumerTypeId': consumerTypeId,
      'operatingVoltageId': operatingVoltageId,
      'installDate': installDate,
      'connectionStatusId': connectionStatusId,
      'connectionTypeId': connectionTypeId,
      'meterTypeId': meterTypeId,
      'meterNumber': meterNumber,
      'meterModel': meterModel,
      'meterManufacturer': meterManufacturer,
      'sanctionedLoad': sanctionedLoad,
      'connectedLoad': connectedLoad,
      'businessTypeId': businessTypeId,
      'othersBusiness': othersBusiness,
      'accountNumber': accountNumber,
      'specialCode': specialCode,
      'specialType': specialType,
      'locationId': locationId,
      'billGroup': billGroup,
      'bookNumber': bookNumber,
      'omfKwh': omfKwh,
      'meterReading': meterReading,
      'serviceCableSize': serviceCableSize,
      'serviceCableTypeId': serviceCableTypeId,
      'customerAddress': customerAddress,
      'unionGeoCode': unionGeoCode,
      'union': union,
      'plotNo': plotNo,
      'buildingAptNo': buildingAptNo,
      'premiseName': premiseName,
      'surveyDate': surveyDate,
      'latitude': latitude,
      'longitude': longitude,
      'structureId': structureId,
      'structureMapNo': structureMapNo,
      'structureTypeId': structureTypeId,
      'consumerToStructureType': consumerToStructureType,
      'numberOfFloor': numberOfFloor,
      'distanceFromSp': distanceFromSp,
      'startingDate': startingDate,
      'endingDate': endingDate?.toIso8601String(),
      'activationStatusId': activationStatusId,
      'dataActivationStatus': dataActivationStatus,
      'verificationStateId': verificationStateId,
      'distance_from_sp': distance_from_sp,
      'dataVerificationState': dataVerificationState,
      'remarks': remarks,
    };
  }
}
